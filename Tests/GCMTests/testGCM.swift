//
//  testGCM.swift
//  VaporGCM
//
//  Created by Shial on 11/04/2017.
//
//

import XCTest
@testable import Vapor
@testable import HTTP

class testGCM: XCTestCase {
    static let allTests = [
        ("testGCM", testGCM),
        ("testNotification", testNotification),
        ("testNotificationToJSON", testNotificationToJSON),
        ("testPushMessage", testPushMessage),
        ("testSendMessageToDevice", testSendMessageToDevice),
        ("testSendMessageToMultipleDevices", testSendMessageToMultipleDevices)
    ]
    
    var drop: Droplet! = nil
    
    override func setUp() {
        super.setUp()
        drop = try! Droplet.makeTestDroplet()
    }
    
    override func tearDown() {
        super.tearDown()
        drop = nil
    }
    
    func testGCM() {
        let gcm = VaporGCM(forDroplet: drop, serverKey: "bk3RNwTe3H0:CI2k_HHwgIpoDKCIZvvDMExUdFQ3P1...")
        XCTAssertNotNil(gcm)
    }
    
    func testNotification() {
        let notification = Notification()
        XCTAssertNotNil(notification)
    }
    
    func testNotificationToJSON() {
        let notification = Notification()
        var json: JSON?
        do {
            json = try notification.makeJSON()
        } catch {
            XCTFail()
        }
        XCTAssertNotNil(json)
    }
    
    func testPushMessage() {
        var message: PushMessage?
        do {
            message = try PushMessage()
        } catch {
            XCTFail()
        }
        XCTAssertNotNil(message)
    }
    
    func testSendMessageToDevice() {
        let gcm = VaporGCM(forDroplet: drop, serverKey: "bk3RNwTe3H0:CI2k_HHwgIpoDKCIZvvDMExUdFQ3P1...")
        do {
            let message = try PushMessage()
            let response = try gcm.send(message, to: "bk3RNwTe3H0:CI2k_HHwgIpoDKCIZvvDMExUdFQ3P1...")
            XCTAssertNotNil(response)
        } catch {
            XCTFail()
        }
    }
    
    func testSendMessageToMultipleDevices() {
        let gcm = VaporGCM(forDroplet: drop, serverKey: "bk3RNwTe3H0:CI2k_HHwgIpoDKCIZvvDMExUdFQ3P1...")
        let expectation = self.expectation(description: "asynchronous request")

        do {
            let message = try PushMessage()
            var count = 0
            try! gcm.send(message, to: ["1","2","3"], responseHandler: { (token, response, error) in
                guard error == nil else {
                    XCTFail()
                    return
                }
                XCTAssert(true)
                count = count + 1
                if count == 3 {
                    expectation.fulfill()
                }
                
            })
        } catch {
            XCTFail()
        }
        self.waitForExpectations(timeout: 10.0, handler: nil)
    }
}
