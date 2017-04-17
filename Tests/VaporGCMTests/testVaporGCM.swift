//
//  testVaporGCM.swift
//  VaporGCM
//
//  Created by Shial on 11/04/2017.
//
//

import XCTest
@testable import Vapor
@testable import HTTP
@testable import VaporGCM

class testVaporGCM: XCTestCase {
    static let allTests = [
        ("testGCM", testGCM),
        ("testNotification", testNotification),
        ("testNotificationToJSON", testNotificationToJSON),
        ("testNotificationFields", testNotificationFields),
        ("testNotificationMessage", testNotificationMessage),
        ("testNotificationBodyWithTitle", testNotificationBodyWithTitle),
        ("testPushMessage", testPushMessage),
        ("testPushMessageFields", testPushMessageFields),
        ("testSendMessageToDevice", testSendMessageToDevice),
        ("testSendMessageToMultipleDevices", testSendMessageToMultipleDevices),
        ("testDeviceGroup", testDeviceGroup),
        ("testNoDroplet", testNoDroplet),
        ("testNoDroplet", testNoDroplet2),
        ("testNoDroplet", testNoDroplet3)
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
        let gcmPayload = GCMPayload()
        XCTAssertNotNil(gcmPayload)
    }
    
    func testNotificationMessage() {
        let gcmPayload = GCMPayload(message: "message")
        do {
            let json = try gcmPayload.makeJSON()
            let value: String = try json.extract("body")
            XCTAssertNotNil(value)
        } catch {
            XCTFail()
        }
        XCTAssertNotNil(gcmPayload)
    }
    
    func testNotificationBodyWithTitle() {
        let gcmPayload = GCMPayload(title: "title", body: "body")
        do {
            let json = try gcmPayload.makeJSON()
            let value1: String = try json.extract("title")
            XCTAssertNotNil(value1)
            let value2: String = try json.extract("body")
            XCTAssertNotNil(value2)
        } catch {
            XCTFail()
        }
        XCTAssertNotNil(gcmPayload)
    }
    
    func testNotificationToJSON() {
        let gcmPayload = GCMPayload()
        var json: JSON?
        do {
            json = try gcmPayload.makeJSON()
        } catch {
            XCTFail()
        }
        XCTAssertNotNil(json)
    }
    
    func testNotificationFields() {
        var gcmPayload = GCMPayload()
        gcmPayload.title = "title"
        gcmPayload.body = "body"
        gcmPayload.sound = "sound"
        gcmPayload.tag = "tag"
        gcmPayload.color = "color"
        gcmPayload.clickAction = "click_action"
        gcmPayload.bodyLocKey = "body_loc_key"
        gcmPayload.bodyLocArgs = JSON([:])
        gcmPayload.titleLocKey = JSON([:])
        gcmPayload.titleLocArgs = JSON([:])
        do {
            let json = try gcmPayload.makeJSON()
            try ["title","body","sound","tag","color","click_action","body_loc_key"].forEach() { key in
                let value: String = try json.extract(key)
                XCTAssertNotNil(value)
            }
        } catch {
            XCTFail()
        }
        do {
            let json = try gcmPayload.makeJSON()
            try ["body_loc_args","title_loc_key","title_loc_args"].forEach() { key in
                let value: JSON = try json.extract(key)
                XCTAssertNotNil(value)
            }
        } catch {
            XCTFail()
        }
        XCTAssertNotNil(gcmPayload)
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
    
    func testPushMessageFields() {
        var message: PushMessage?
        let gcmPayload = GCMPayload()
        let data = JSON([
            "score":"5x1",
            "time":"15:10"
            ])
        do {
            message = try PushMessage(gcmPayload: gcmPayload, data: data)
        } catch {
            XCTFail()
        }
        message?.priority = GCMPMessagePriority.high
        message?.timeToLive = 5
        message?.collapseKey = "Collapse"
        message?.restrictedPackageName = "Package"
        message?.dryRun = true
        
        do {
            let json = try message?.makeJSON(recipient: "token11")
            
            let value1: JSON? = try json?.extract("notification")
            XCTAssertNotNil(value1)
            
            let value2: JSON? = try json?.extract("data")
            XCTAssertNotNil(value2)
            
            let value3: String? = try json?.extract("priority")
            XCTAssertTrue(value3 == "high")
            
            let value4: Int? = try json?.extract("time_to_live")
            XCTAssertTrue(value4 == 5)
            
            let value5: String? = try json?.extract("collapse_key")
            XCTAssertTrue(value5 == "Collapse")
            
            let value6: String? = try json?.extract("restricted_package_name")
            XCTAssertTrue(value6 == "Package")
            
            let value7: Bool? = try json?.extract("dry_run")
            XCTAssertTrue(value7 == true)
            
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
    
    func testDeviceGroup() {
        let gcm = VaporGCM(forDroplet: drop, serverKey: "bk3RNwTe3H0:CI2k_HHwgIpoDKCIZvvDMExUdFQ3P1...")
        let group = DeviceGroup(operation: .create,
                                name: "appUser-Chris",
                                registrationIds: ["16", "9"])
        let response = try? gcm.sendDeviceGroup(group, forProject: "SENDER_ID")
        XCTAssertNotNil(response)
    }
    
    func testNoDroplet() {
        var drop: Droplet! = self.drop
        let gcm = VaporGCM(forDroplet: drop, serverKey: "bk3RNwTe3H0:CI2k_HHwgIpoDKCIZvvDMExUdFQ3P1...")
        drop = nil
        do {
            let message = try PushMessage()
            let response = try gcm.send(message, to: "bk3RNwTe3H0:CI2k_HHwgIpoDKCIZvvDMExUdFQ3P1...")
            XCTAssertNotNil(response)
        } catch InitializeError.missingDroplet {
            print("missingDroplet")
            XCTAssertTrue(true)
        } catch {
            XCTFail()
        }
    }
    
    func testNoDroplet2() {
        var drop: Droplet! = self.drop
        let gcm = VaporGCM(forDroplet: drop, serverKey: "bk3RNwTe3H0:CI2k_HHwgIpoDKCIZvvDMExUdFQ3P1...")
        drop = nil
        do {
            let message = try PushMessage()
            try gcm.send(message, to: ["1","2","3"], responseHandler: nil)
        } catch InitializeError.missingDroplet {
            print("missingDroplet")
            XCTAssertTrue(true)
        } catch {
            XCTFail()
        }
    }
    
    func testNoDroplet3() {
        var drop: Droplet! = self.drop
        let gcm = VaporGCM(forDroplet: drop, serverKey: "bk3RNwTe3H0:CI2k_HHwgIpoDKCIZvvDMExUdFQ3P1...")
        drop = nil
        do {
            let group = DeviceGroup(operation: .create,
                                    name: "appUser-Chris",
                                    registrationIds: ["16", "9"])
            _ = try gcm.sendDeviceGroup(group, forProject: "SENDER_ID")
        } catch InitializeError.missingDroplet {
            print("missingDroplet")
            XCTAssertTrue(true)
        } catch {
            XCTFail()
        }
    }
}
