//
//  CloudKitOperation.swift
//  Operations
//
//  Created by Daniel Thorpe on 22/07/2015.
//  Copyright (c) 2015 Daniel Thorpe. All rights reserved.
//

import Foundation
import CloudKit

public protocol CloudKitOperationType: class {
    var database: CKDatabase? { get set }
    func begin()
}

/**
    A very simple wrapper for CloudKit database operations.
    
    The database property is set on the operation, and suitable
    for execution on an `OperationQueue`. This means that 
    observers and conditions can be attached.
*/
public class CloudKitOperation<CloudOperation where CloudOperation: CloudKitOperationType, CloudOperation: NSOperation>: Operation {

    public let operation: CloudOperation

    public init(operation: CloudOperation, database: CKDatabase = CKContainer.defaultContainer().privateCloudDatabase) {
        operation.database = database
        self.operation = operation
        super.init()
    }

    public override func execute() {
        operation.addCompletionBlock {
            self.finish()
        }
        operation.begin()
    }
}

extension CKDatabaseOperation: CloudKitOperationType {

    public func begin() {
        assert(database != nil, "CKDatabase not set on Operation.")
        database!.addOperation(self)
    }
}
