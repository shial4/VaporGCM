//
//  testAndroidGCM.swift
//  VaporAndroidGCM
//
//  Created by Shial on 11/04/2017.
//
//

import XCTest
@testable import Vapor
@testable import HTTP
@testable import VaporAndroidGCM

class testAndroidGCM: XCTestCase {
    static let allTests = [
        ("testAndroidGCM", testAndroidGCM),
        ("testAndroidNotification", testAndroidNotification),
        ("testAndroidNotificationToJSON", testAndroidNotificationToJSON),
        ("testAndroidPushMessage", testAndroidPushMessage),
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
    
    func testAndroidGCM() {
        let gcm = VaporAndroidGCM(forDroplet: drop, serverKey: "bk3RNwTe3H0:CI2k_HHwgIpoDKCIZvvDMExUdFQ3P1...")
        XCTAssertNotNil(gcm)
    }
    
    func testAndroidNotification() {
        let notification = AndroidNotification()
        XCTAssertNotNil(notification)
    }
    
    func testAndroidNotificationToJSON() {
        let notification = AndroidNotification()
        var json: JSON?
        do {
            json = try notification.makeJSON()
        } catch {
            XCTFail()
        }
        XCTAssertNotNil(json)
    }
    
    func testAndroidPushMessage() {
        var message: AndroidPushMessage?
        do {
            message = try AndroidPushMessage()
        } catch {
            XCTFail()
        }
        XCTAssertNotNil(message)
    }
    
    func testSendMessageToDevice() {
        let gcm = VaporAndroidGCM(forDroplet: drop, serverKey: "bk3RNwTe3H0:CI2k_HHwgIpoDKCIZvvDMExUdFQ3P1...")
        do {
            let message = try AndroidPushMessage()
            let response = try gcm.send(message, to: "bk3RNwTe3H0:CI2k_HHwgIpoDKCIZvvDMExUdFQ3P1...")
            XCTAssertNotNil(response)
        } catch {
            XCTFail()
        }
    }
    
    func testSendMessageToMultipleDevices() {
        let gcm = VaporAndroidGCM(forDroplet: drop, serverKey: "bk3RNwTe3H0:CI2k_HHwgIpoDKCIZvvDMExUdFQ3P1...")
        let expectation = self.expectation(description: "asynchronous request")

        do {
            let message = try AndroidPushMessage()
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
