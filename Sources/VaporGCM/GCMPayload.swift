//
//  GCMPayload.swift
//  VaporGCM
//
//  Created by Shial on 11/04/2017.
//
//

import Foundation
import JSON

///Parameters for gcmPayload messaging by platform
public struct GCMPayload {
    //Indicates notification title. This field is not visible on iOS phones and tablets.
    public var title: String?
    //Indicates notification body text.
    public var body: String?
    //Indicates notification icon.
    public var icon: String = "myicon"
    //Indicates a sound to play when the device receives the notification.
    public var sound: String?
    ///Indicates whether each notification message results in a new entry on the notification center. If not set, each request creates a new notification. If set, and a notification with the same tag is already being shown, the new notification replaces the existing one in notification center.
    public var tag: String?
    ///Indicates color of the icon, expressed in #rrggbb format
    public var color: String?
    ///The action associated with a user click on the notification.
    public var clickAction: String?
    ///Indicates the key to the body string for localization.
    public var bodyLocKey: String?
    ///Indicates the string value to replace format specifiers in body string for localization.
    public var bodyLocArgs: JSON?
    ///Indicates the key to the title string for localization.
    public var titleLocKey: JSON?
    ///Indicates the string value to replace format specifiers in title string for localization.
    public var titleLocArgs: JSON?
    
    public func makeJSON() throws -> JSON {
        var payload: [String: NodeRepresentable] = ["icon":icon]
        if let value = title {
            payload["title"] = value
        }
        if let value = body {
            payload["body"] = value
        }
        if let value = sound {
            payload["sound"] = value
        }
        if let value = tag {
            payload["tag"] = value
        }
        if let value = color {
            payload["color"] = value
        }
        if let value = clickAction {
            payload["click_action"] = value
        }
        if let value = bodyLocKey {
            payload["body_loc_key"] = value
        }
        if let value = bodyLocArgs {
            payload["body_loc_args"] = value
        }
        if let value = titleLocKey {
            payload["title_loc_key"] = value
        }
        if let value = titleLocArgs {
            payload["title_loc_args"] = value
        }
        let json = try JSON(node: try payload.makeNode())
        return json
    }
}
