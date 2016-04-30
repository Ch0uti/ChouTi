//
//  LocationOperations.swift
//  Operations
//
//  Created by Daniel Thorpe on 27/07/2015.
//  Copyright (c) 2015 Daniel Thorpe. All rights reserved.
//

import Foundation
import CoreLocation


// MARK: Consumer Interfaces -

// MARK: UserLocationOperation

/**
Access the device's current location. It will ask for
permission if required.

- parameter accuracy: the location accuracy which defaults to 3km.
- parameter completion: a closure CLLocation -> Void.
*/
public typealias UserLocationOperation = _UserLocationOperation<CLLocationManager>

// MARK: ReverseGeocodeOperation

/**
Reverse geocode a given CLLocation.

- parameter location: the location to reverse lookup.
- parameter completion: a completion block of CompletionBlockType
*/
public typealias ReverseGeocodeOperation = _ReverseGeocodeOperation<CLGeocoder>

// MARK: ReverseGeocodeUserLocationOperation

/**
Reverse geocode the device's current location.

- parameter accuracy: the location accuracy.
- parameter completion: a completion block of CompletionBlockType
*/
public typealias ReverseGeocodeUserLocationOperation = _ReverseGeocodeUserLocationOperation<CLGeocoder, CLLocationManager>

@available(*, unavailable, renamed="UserLocationOperation")
public typealias LocationOperation = UserLocationOperation

// MARK: - Implementation Details -

public protocol LocationManagerType: LocationCapabilityRegistrarType {
    func opr_setDesiredAccuracy(desiredAccuracy: CLLocationAccuracy)
    func opr_startUpdatingLocation()
    func opr_stopLocationUpdates()
}

extension CLLocationManager: LocationManagerType {

    public func opr_setDesiredAccuracy(accuracy: CLLocationAccuracy) {
        desiredAccuracy = accuracy
    }

    public func opr_startUpdatingLocation() {
        startUpdatingLocation()
    }

    public func opr_stopLocationUpdates() {
        stopUpdatingLocation()
    }
}

public enum LocationOperationError: ErrorType, Equatable {
    case LocationManagerDidFail(NSError)
    case GeocoderError(NSError)
}

public class _UserLocationOperation<Manager: LocationManagerType>: Operation, CLLocationManagerDelegate, ResultOperationType {
    public typealias CompletionBlockType = CLLocation -> Void

    private let manager: Manager
    private let accuracy: CLLocationAccuracy
    private let completion: CompletionBlockType

    /// - returns: the CLLocation if available
    public private(set) var location: CLLocation? = .None

    /// - returns: the CLLocation if available
    public var result: CLLocation? {
        return location
    }

    /**
     Initialize an operation which will use a custom location manager to
     determine the user's current location to the desired accuracy. It will ask for
     permission if required.

     Framework consumers should use: UserLocationOperation

     - parameter accuracy: the location accuracy which defaults to 3km.
     - parameter completion: a closure CLLocation -> Void.
    */
    public convenience init(accuracy: CLLocationAccuracy = kCLLocationAccuracyThreeKilometers, completion: CompletionBlockType = { _ in }) {
        self.init(manager: Manager(), accuracy: accuracy, completion: completion)
    }

    /**
    Initialize an operation which will use a custom location manager to
    determine the user's current location to the desired accuracy. It will ask for
    permission if required.

     - parameter manager: instance of a type which implements LocationManagerType.
     - parameter accuracy: the location accuracy which defaults to 3km.
     - parameter completion: a closure CLLocation -> Void.
    */
    public init(manager: Manager, accuracy: CLLocationAccuracy, completion: CompletionBlockType) {
        self.manager = manager
        self.accuracy = accuracy
        self.completion = completion
        super.init()
        name = "User Location"
        let capability = Capability.Location(.WhenInUse)
        capability.registrar = manager
        addCondition(AuthorizedFor(capability))
        addCondition(MutuallyExclusive<CLLocationManager>())
        addObserver(CancelledObserver { [weak self] _ in
            dispatch_async(Queue.Main.queue) {
                self?.stopLocationUpdates()
            }
        })
    }

    deinit {
        stopLocationUpdates()
    }

    /// Starts updating the location
    public override func execute() {
        manager.opr_setDesiredAccuracy(accuracy)
        manager.opr_setDelegate(self)
        manager.opr_startUpdatingLocation()
    }

    internal func stopLocationUpdates() {
        manager.opr_stopLocationUpdates()
        manager.opr_setDelegate(nil)
    }

    @objc public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !finished, let location = locations.last {
            log.info("Updated last location: \(location)")
            if location.horizontalAccuracy <= accuracy {
                dispatch_async(Queue.Main.queue) { [weak self] in
                    if let weakSelf = self {
                        if !weakSelf.finished {
                            weakSelf.stopLocationUpdates()
                            weakSelf.location = location
                            weakSelf.completion(location)
                            weakSelf.finish()
                        }
                    }
                }
            }
        }
    }

    @objc public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        dispatch_async(Queue.Main.queue) { [weak self] in
            if let weakSelf = self {
                weakSelf.stopLocationUpdates()
                weakSelf.finish(LocationOperationError.LocationManagerDidFail(error))
            }
        }
    }
}

public protocol ReverseGeocoderType {
    init()
    func opr_cancel()
    func opr_reverseGeocodeLocation(location: CLLocation, completion: ([CLPlacemark], NSError?) -> Void)
}

extension CLGeocoder: ReverseGeocoderType {

    public func opr_cancel() {
        cancelGeocode()
    }

    public func opr_reverseGeocodeLocation(location: CLLocation, completion: ([CLPlacemark], NSError?) -> Void) {
        reverseGeocodeLocation(location) { (results, error) in
            completion(results ?? [], error)
        }
    }
}

public class _ReverseGeocodeOperation<Geocoder: ReverseGeocoderType>: Operation, ResultOperationType {
    public typealias CompletionBlockType = CLPlacemark -> Void

    public let location: CLLocation

    private let geocoder: Geocoder
    private let completion: CompletionBlockType

    /// - returns: the CLPlacemark from the geocoder
    public private(set) var placemark: CLPlacemark? = .None

    /// - returns: the CLPlacemark from the geocoder
    public var result: CLPlacemark? {
        return placemark
    }

    /**
    Initialize an operation which will use a custom geocoder to
    reverse lookup the given location.

    Framework consumers see: ReverseGeocodeOperation

    - parameter location: the location to reverse lookup.
    - parameter completion: a completion block of CompletionBlockType
    */
    public convenience init(location: CLLocation, completion: CompletionBlockType = { _ in }) {
        self.init(geocoder: Geocoder(), location: location, completion: completion)
    }

    /**
    Initialize an operation which will use a custom geocoder to
    reverse lookup the given location.

    - parameter geocoder: instance of a type which implements ReverseGeocoderType.
    - parameter location: the location to reverse lookup.
    - parameter completion: a completion block of CompletionBlockType
    */
    public init(geocoder: Geocoder, location: CLLocation, completion: CompletionBlockType) {
        self.location = location
        self.geocoder = geocoder
        self.completion = completion
        super.init()
        name = "Reverse Geocode"
        addObserver(NetworkObserver())
        addObserver(BackgroundObserver())
        addCondition(MutuallyExclusive<ReverseGeocodeOperation>())
        addObserver(CancelledObserver { [weak self] _ in
            if let geocoder = self?.geocoder {
                dispatch_async(Queue.Main.queue) {
                    geocoder.opr_cancel()
                }
            }
        })
    }

    public override func execute() {
        geocoder.opr_reverseGeocodeLocation(location) { results, error in
            dispatch_async(Queue.Main.queue) { [weak self] in
                if let weakSelf = self {
                    if !weakSelf.finished {
                        if let error = error {
                            weakSelf.finish(LocationOperationError.GeocoderError(error))
                        }
                        else if let placemark = results.first {
                            weakSelf.placemark = placemark
                            weakSelf.completion(placemark)
                            weakSelf.finish()
                        }
                    }
                }
            }
        }
    }
}

public class _ReverseGeocodeUserLocationOperation<Geocoder, Manager where Geocoder: ReverseGeocoderType, Manager: LocationManagerType>: GroupOperation, ResultOperationType {
    public typealias CompletionBlockType = (CLLocation, CLPlacemark) -> Void

    private let geocoder: Geocoder
    private let completion: CompletionBlockType
    private let userLocationOperation: _UserLocationOperation<Manager>
    private var reverseGeocodeOperation: _ReverseGeocodeOperation<Geocoder>?

    /// - returns: the CLLocation if available
    public var location: CLLocation? {
        return userLocationOperation.location
    }

    /// - returns: the CLPlacemark from the geocoder
    public var placemark: CLPlacemark? {
        return reverseGeocodeOperation?.placemark
    }

    /// - returns: the CLPlacemark from the geocoder, note that CLPlacemark
    /// composes the associated CLLocation.
    public var result: CLPlacemark? {
        return placemark
    }

    /**
    Initialize a group operation which will use a custom geocoder to
    reverse lookup the device location (using a custom location manager).

    Framework consumers see: ReverseGeocodeUserLocationOperation

    - parameter accuracy: the location accuracy.
    - parameter completion: a completion block of CompletionBlockType
    */
    public convenience init(accuracy: CLLocationAccuracy = kCLLocationAccuracyThreeKilometers, completion: CompletionBlockType = { _, _ in }) {
        self.init(geocoder: Geocoder(), manager: Manager(), accuracy: accuracy, completion: completion)
    }

    /**
    Initialize a group operation which will use a custom geocoder to
    reverse lookup the device location (using a custom location manager).

    - parameter geocoder: instance of a type which implements ReverseGeocoderType.
    - parameter manager: instance of a type which implements LocationManagerType.
    - parameter accuracy: the location accuracy.
    - parameter completion: a completion block of CompletionBlockType
    */
    public init(geocoder: Geocoder, manager: Manager, accuracy: CLLocationAccuracy, completion: CompletionBlockType) {
        self.geocoder = geocoder
        self.completion = completion
        self.userLocationOperation = _UserLocationOperation(manager: manager, accuracy: accuracy, completion: { _ in })
        super.init(operations: [ userLocationOperation ])
        name = "Reverse Geocode User Location"
        addCondition(MutuallyExclusive<ReverseGeocodeUserLocationOperation>())
    }

    public override func willFinishOperation(operation: NSOperation, withErrors errors: [ErrorType]) {
        if errors.isEmpty && userLocationOperation == operation && !operation.cancelled {
            if let location = location {
                let reverseOp = _ReverseGeocodeOperation(geocoder: geocoder, location: location) { [unowned self] placemark in
                    self.completion(location, placemark)
                }
                addOperation(reverseOp)
                reverseGeocodeOperation = reverseOp
            }
        }
    }
}

public func == (lhs: LocationOperationError, rhs: LocationOperationError) -> Bool {
    switch (lhs, rhs) {
    case let (.LocationManagerDidFail(aError), .LocationManagerDidFail(bError)):
        return aError == bError
    case let (.GeocoderError(aError), .GeocoderError(bError)):
        return aError == bError
    default:
        return false
    }
}
