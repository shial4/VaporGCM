import Foundation
import JSON
import Vapor
import HTTP

///VaporGCM take messages from the application server and send them to the Google Cloud Messaging over HTTP.
open class VaporGCM {
    fileprivate let baseURL: String = "https://fcm.googleapis.com/fcm/send"
    fileprivate let creatingDeviceGroupURL = "https://android.googleapis.com/gcm/notification"
    /**
     Starting from September 2016, you can create new server keys only in the Firebase Console using the Cloud Messaging tab of the Settings panel. Existing projects that need to create a new server key can be imported in the Firebase console without affecting their existing configuration.
     */
    public var key: String
    ///Instance of Droplet used to send message
    public weak var drop: Droplet?
    /**
     The only thing required to create an instance of VaporGCM is your Droplet instance used to send message over HTTP and your server key required for authorisation.
     - parameter drop: Your instance of Droplet stored as weak object to prevent retain cycle
     - parameter key: A server key that authorizes your app server for access to Google services, including sending messages via Firebase Cloud Messaging. You obtain the server key when you create your Firebase project. You can view it in the Cloud Messaging tab of the Firebase console Settings pane.
     */
    public init(forDroplet drop: Droplet, serverKey key: String) {
        self.drop = drop
        self.key = key
    }
    /**
     Send the notification message to multiple device with token.
     
     From the server side, sending messages to a Firebase Cloud Messaging topic is very similar to sending messages to an individual device or to a user group. The app server sets the to key with a value like /topics/yourTopic. Developers can choose any topic name that matches the regular expression: `/topics/[a-zA-Z0-9-_.~%]+`
     
     - parameter message: Object represent PushMessage type
     - parameter deviceToken: Device token or topic to which message will be send
     - returns: return POST notification Response object, So you can handle error or proceed with futher interpretation
     */
    open func send(_ message: PushMessage, to deviceToken: String) throws -> Response {
        guard let drop = drop else {
            throw InitializeError.missingDroplet
        }
        let headers: [HeaderKey : String] = [
            "Authorization":"key=\(key)",
            "Content-Type":"application/json"
        ]
        let body = try Body(message.makeJSON(recipient: deviceToken))
        return try drop.client.post(baseURL, headers, body)
    }
    /**
     Send the notification message to multiple devices
     - parameter message: Object represent `PushMessage` type
     - parameter deviceTokens: Array of device tokens to which notification will be send
     - parameter responseHander: Called each time message `Response` object is received, Identified by device token. So you can handle error or proceed with futher interpretation. This block is called for each notification response sended to device.
     */
    open func send(_ message: PushMessage, to deviceTokens: [String], responseHandler: ((_ token: String, _ response: Response?, _ error: Error?) -> ())?) throws {
        guard let drop = drop else {
            throw InitializeError.missingDroplet
        }
        let headers: [HeaderKey : String] = [
            "Authorization":"key=\(key)",
            "Content-Type":"application/json"
        ]
        deviceTokens.forEach() {[weak self] token in
            guard let strongSelf = self else {
                responseHandler?(token, nil, GCMSendMessageError.objectDealocated)
                return
            }
            do {
                let body = try Body(message.makeJSON(recipient: token))
                let response = try drop.client.post(strongSelf.baseURL, headers, body)
                responseHandler?(token, response, nil)
            } catch {
                responseHandler?(token, nil, error)
            }
        }
    }
    
    /**
     To create a device group, send a POST request that provides a name for the group, and a list of registration tokens for the devices.
     
     The `name` is a `notification_key_name` (e.g., it can be a username) that is unique to a given group. The `notification_key_name` and `notification_key` are unique to a group of registration tokens. It is important that `notification_key_name` is unique per client app if you have multiple client apps for the same sender ID. This ensures that messages only go to the intended target app.
     
     - parameter id: A unique numerical value created when you create your Firebase project, available in the Cloud Messaging tab of the Firebase console Settings pane. The sender ID is used to identify each app server that can send messages to the client app.
     - parameter group: deviceToken Device token or topic to which message will be send
     - returns: FCM returns a new notification_key that represents the device group.
     */
    open func sendDeviceGroup(_ group: DeviceGroup, forProject id: String) throws -> Response {
        guard let drop = drop else {
            throw InitializeError.missingDroplet
        }
        let headers: [HeaderKey : String] = [
            "project_id":id,
            "Authorization":"key=\(key)",
            "Content-Type":"application/json"
        ]
        let body = try Body(group.makeJSON())
        return try drop.client.post(creatingDeviceGroupURL, headers, body)
    }
}
