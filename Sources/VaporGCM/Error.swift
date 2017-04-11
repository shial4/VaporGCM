//
//  Error.swift
//  VaporAndroidGCM
//
//  Created by Shial on 11/04/2017.
//
//

import Foundation

public enum InitializeError: Error, CustomStringConvertible {
    case missingDroplet
    
    public var description: String {
        switch self {
            case .missingDroplet: return "Missing Droplet object. This is required to pass messages from your app server."
        }
    }
}

public enum GCMSendMessageError: Error, CustomStringConvertible {
    case objectDealocated
    
    public var description: String {
        switch self {
        case .objectDealocated: return "VaporAndroidGCM object was dealocated."
        }
    }
}
