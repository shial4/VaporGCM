//
//  PushMessage.swift
//  VaporGCM
//
//  Created by Shial on 11/04/2017.
//
//

import Foundation
import JSON

///Priority of the push message.
public enum GCMPMessagePriority: String {
    case normal = "normal"
    case high = "high"
}

///Message passed from your app server to client apps via GCM
public struct PushMessage {
    ///This parameter specifies the predefined, user-visible key-value pairs of the notification payload.
    public let notification: Notification?
    ///This parameter specifies the custom key-value pairs of the message's payload.
    public let data: JSON?
    ///This parameter identifies a group of messages (e.g., with collapse_key: "Updates Available") that can be collapsed, so that only the last message gets sent when delivery can be resumed. This is intended to avoid sending too many of the same messages when the device comes back online or becomes active.
    public var collapseKey: String?
    ///This parameter specifies how long (in seconds) the message should be kept in GCM storage if the device is offline. The maximum time to live supported is 4 weeks, and the default value is 4 weeks
    public var timeToLive: Int?
    ///Sets the priority of the message.
    public var priority: GCMPMessagePriority?
    ///This parameter specifies the package name of the application where the registration tokens must match in order to receive the message.
    public var restrictedPackageName: String?
    ///This parameter, when set to true, allows developers to test a request without actually sending a message.
    public var dryRun: Bool?
    
    public init(notification: Notification? = nil, data: JSON? = nil) throws {
        self.notification = notification
        self.data = data
    }
    
    public func makeJSON(recipient: String) throws -> JSON {
        var payloadData: [String: NodeRepresentable] = [
            "to":recipient
        ]
        if let notificationData = notification {
            payloadData["notification"] = try notificationData.makeJSON()
        }
        if let payload = data {
            payloadData["data"] = payload
        }
        if let priority = priority?.rawValue {
            payloadData["priority"] = priority
        }
        if let time = timeToLive {
            payloadData["time_to_live"] = time
        }
        if let key = collapseKey {
            payloadData["collapse_key"] = key
        }
        if let name = restrictedPackageName {
            payloadData["restricted_package_name"] = name
        }
        if let run = dryRun {
            payloadData["dry_run"] = run
        }
        let json = try JSON(node: try payloadData.makeNode())
        return json
    }
}
