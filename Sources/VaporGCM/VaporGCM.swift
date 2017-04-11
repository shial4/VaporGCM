import Foundation
import JSON
import Vapor
import HTTP

///VaporGCM take messages from the application server and send them to the Google Cloud Messaging over HTTP.
open class VaporGCM {
    fileprivate let baseURL: String = "https://gcm-http.googleapis.com/gcm/send"
    /**
     Starting from September 2016, you can create new server keys only in the Firebase Console using the Cloud Messaging tab of the Settings panel. Existing projects that need to create a new server key can be imported in the Firebase console without affecting their existing configuration.
     */
    public var key: String
    ///Instance of Droplet used to send message
    public weak var drop: Droplet?
    /**
     The only thing required to create an instance of VaporGCM is your Droplet instance used to send message over HTTP and your server key required for authorisation.
     - parameter drop Your instance of Droplet stored as weak object to prevent retain cycle
     - parameter key Your server key
     */
    init(forDroplet drop: Droplet, serverKey key: String) {
        self.drop = drop
        self.key = key
    }
    /**
     Send the notification message to multiple device with token.
     - parameter message Object represent PushMessage type
     - parameter deviceToken Device token to which notification will be send
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
        return try drop.client.post(baseURL, headers: headers, body: body)
    }
    /**
     Send the notification message to multiple devices
     - parameter message Object represent PushMessage type
     - parameter deviceTokens Array of device tokens to which notification will be send
     - parameter responseHander Called each time notification Response object is received, Identified by device token. So you can handle error or proceed with futher interpretation. This block is called for each notification response sended to device.
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
                let response = try drop.client.post(strongSelf.baseURL, headers: headers, body: body)
                responseHandler?(token, response, nil)
            } catch {
                responseHandler?(token, nil, error)
            }
        }
    }
}
