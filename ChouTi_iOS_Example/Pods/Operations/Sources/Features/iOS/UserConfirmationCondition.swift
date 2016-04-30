//
//  UserConfirmationCondition.swift
//  Operations
//
//  Created by Daniel Thorpe on 05/08/2015.
//  Copyright (c) 2015 Daniel Thorpe. All rights reserved.
//

import UIKit

enum UserConfirmationResult {
    case Unknown
    case Confirmed
    case Cancelled
}

enum UserConfirmationError: ErrorType {
    case ConfirmationUnknown
    case ConfirmationCancelled
}

/**
    Attach this condition to an operation to present an alert
    to the user requesting their confirmation before proceeding.
*/
public class UserConfirmationCondition<From: PresentingViewController>: OperationCondition {

    public let name: String
    public let isMutuallyExclusive = false

    private let action: String
    private let isDestructive: Bool
    private let cancelAction: String
    private var alert: AlertOperation<From>
    private var confirmation: UserConfirmationResult = .Unknown
    private var alertOperationErrors = [ErrorType]()

    public init(title: String, message: String? = .None, action: String, isDestructive: Bool = true, cancelAction: String = NSLocalizedString("Cancel", comment: "Cancel"), presentConfirmationFrom from: From) {
        self.action = action
        self.isDestructive = isDestructive
        self.cancelAction = cancelAction
        self.alert = AlertOperation(presentAlertFrom: from)
        self.alert.title = title
        self.alert.message = message
        self.name = "UserConfirmationCondition(\(title))"
    }

    public func dependencyForOperation(operation: Operation) -> NSOperation? {
        alert.addActionWithTitle(action, style: isDestructive ? .Destructive : .Default) { [weak self] _ in
            self?.confirmation = .Confirmed
        }
        alert.addActionWithTitle(cancelAction, style: .Cancel) { [weak self] _ in
            self?.confirmation = .Cancelled
        }
        alert.addObserver(self)
        return alert
    }

    public func evaluateForOperation(operation: Operation, completion: OperationConditionResult -> Void) {
        switch confirmation {
        case .Unknown:
            // This should never happen, but you never know.
            completion(.Failed(UserConfirmationError.ConfirmationUnknown))
        case .Cancelled:
            completion(.Failed(UserConfirmationError.ConfirmationCancelled))
        case .Confirmed:
            completion(.Satisfied)
        }
    }
}

extension UserConfirmationCondition: OperationDidFinishObserver {

    public func didFinishOperation(operation: Operation, errors: [ErrorType]) {
        if operation == alert {
            alertOperationErrors = errors
        }
    }
}
