//
//  Droplet+Test.swift
//  Cosma
//
//  Created by Shial on 16/02/2017.
//
//

@testable import Vapor
@testable import HTTP

extension Droplet {
    class func makeTestDroplet() throws -> Droplet {
        let drop = Droplet(arguments: ["dummy/path/", "prepare"])
        return drop
    }
}
