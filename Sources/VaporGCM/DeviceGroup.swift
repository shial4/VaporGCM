//
//  DeviceGroup.swift
//  VaporGCM
//
//  Created by Shial on 12/04/2017.
//
//

import JSON

///Request operation type
public enum DeviceGroupOperation: String {
    ///Create a device group
    case create = "create"
    ///Add devices from an existing group
    case add = "add"
    ///Remove devices from an existing group.
    ///If you remove all existing registration tokens from a device group, FCM deletes the device group.
    case remove = "remove"
}

///With device group messaging, you can send a single message to multiple instances of an app running on devices belonging to a group. Typically, "group" refers a set of different devices that belong to a single user. All devices in a group share a common notification key, which is the token that FCM uses to fan out messages to all devices in the group.
public struct DeviceGroup {
    ///Operation parameter for the request
    public let operation: DeviceGroupOperation
    ///name or identifier
    public let notificationKeyName: String
    ///deviceToken Device token or topic to which message will be send
    public let registrationIds: [String]
    
    /**
     Create DeviceGroup instance
     
     - parameter operation: Operation parameter for the request
     - parameter name: Name or identifier
     - parameter registrationIds: Device token or topic to which message will be send
     */
    public init(operation: DeviceGroupOperation, name: String, registrationIds: [String]) {
        self.operation = operation
        self.notificationKeyName = name
        self.registrationIds = registrationIds
    }
    
    public func makeJSON() throws -> JSON {
        let json = try JSON([
            "operation": operation.rawValue.makeNode(in: nil),
            "notification_key_name": notificationKeyName.makeNode(in: nil),
            "registration_ids": try registrationIds.makeNode(in: nil)
            ].makeNode(in: nil))
        return json
    }
}
