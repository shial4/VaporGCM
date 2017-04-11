# VaporAndroidGCM

[![Language](https://img.shields.io/badge/Swift-3-brightgreen.svg)](http://swift.org)
![Vapor](https://img.shields.io/badge/Vapor-1.0.0-green.svg)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/shial4/VaporAndroidGCM/master/license)

AndroidGCM is a simple, yet elegant, Swift library that allows you to send Android Push Notifications using HTTP protocol in Linux & macOS. Created for Vapor

## 🔧 Installation

A quick guide, step by step, about how to use this library.

### 1- Add VaporAndroidGCM to your project

Add the following dependency to your `Package.swift` file:

```swift
.Package(url:"https://github.com/shial4/VaporAndroidGCM.git", majorVersion: 0, minor: 1)
```

And then make sure to regenerate your xcode project. You can use `vapor xcode -y` command, if you have the Vapor toolbox installed.

## 🚀 Usage

It's really easy to get started with the VaporAndroidGCM library! First you need to import the library, by adding this to the top of your Swift file:
```swift
import VaporAndroidGCM
```
The easiest way to setup VaporAndroidGCM is to create object for example in your `main.swift` file. Like this:
```swift
import Vapor
import VaporAndroidGCM

let drop = Droplet()
let gcm = VaporAndroidGCM(forDroplet: drop, serverKey: "bk3RNwTe3H0:CI2k_HHwgIpoDKCIZvvDMExUdFQ3P1...")
```
After you have the VaporAndroidGCM instance, we can go ahead and create notification object. To do that we need to use `AndroidNotification`
```swift
let notification = AndroidNotification()
```
Creating object is simple but it comes with multiple properties to configure:
1. title `title`
Indicates notification title. This field is not visible on iOS phones and tablets.
2. body `body`
Indicates notification body text.
3. icon `icon`
Indicates notification icon. Default value is set to `myicon` 
4. sound `sound`
Indicates a sound to play when the device receives the notification.
5. tag `tag`
Indicates whether each notification message results in a new entry on the notification center on Android. If not set, each request creates a new notification. If set, and a notification with the same tag is already being shown, the new notification replaces the existing one in notification center.
6. color `color`
Indicates color of the icon, expressed in #rrggbb format
7. clickAction `clickAction`
The action associated with a user click on the notification.
8. bodyLocKey `bodyLocKey`
Indicates the key to the body string for localization.
9. bodyLocArgs `bodyLocArgs`
Indicates the string value to replace format specifiers in body string for localization.
10. titleLocKey `titleLocKey`
Indicates the key to the title string for localization.
11. titleLocArgs `titleLocArgs`
Indicates the string value to replace format specifiers in title string for localization.


Despite of notification object we can add custom data to our message. To do that we will need Vapor `JSON` object 

After we've created the notification object it's time to actually send the push message.
```swift
let data = JSON([
"score":"5x1",
"time":"15:10"
])
```
We can now create message bject which is required to send notification to device
```swift
let message = AndroidPushMessage(notification: notification, data: data)
```
Message object do not require AndroidNotification or JSON object. We can as well send empty message.
```swift
let message = try? AndroidPushMessage()
```
We can create message just with notification peyload
```swift
let message = try? AndroidPushMessage(notification: notification)
```
Or just with data payload
```swift
let message = try? AndroidPushMessage(data: data)
```

Now we can send the message with notification payload and data payload to just one device, using:
```swift
let message = try! AndroidPushMessage(notification: notification, data: data)
let response = try? gcm.send(message, to: "bk3RNwTe3H0:CI2k_HHwgIpoDKCIZvvDMExUdFQ3P1...")
```
Sending message to device return Vapor `Response` object. Thanks to that we can interprate response by ourselfs and do futher steps.

VaporAndroidGCM allows us to send message to multiple device list at once by using: 

```swift
try! gcm.send(message, to: ["","",""], responseHandler: { (token, response, error) in
    guard error == nil else {
        print("Something wrong happen")
        return
    }
    guard response?.status.statusCode == 200 else {
        print("Error from server")
        return
    }
    print("Device token: \(token)")
})
```
Sending message to multiple device return response by `responseHandler` for each device received and identyfied by token.

Done!
To summarize
```swift
import Vapor
import VaporAndroidGCM

let drop = Droplet()
let gcm = VaporAndroidGCM(forDroplet: drop, serverKey: "bk3RNwTe3H0:CI2k_HHwgIpoDKCIZvvDMExUdFQ3P1...")

let notification = AndroidNotification()
let data = JSON([
    "score":"5x1",
    "time":"15:10"
])

let message = try! AndroidPushMessage(notification: notification, data: data)
let response = try? gcm.send(message, to: "bk3RNwTe3H0:CI2k_HHwgIpoDKCIZvvDMExUdFQ3P1...")
try! gcm.send(message, to: ["","",""], responseHandler: { (token, response, error) in
    guard error == nil else {
        print("Something wrong happen")
        return
    }
    guard response?.status.statusCode == 200 else {
        print("Error from server")
        return
    }
    print("Device token: \(token)")
})
```

## ⭐ Contributing

Be welcome to contribute to this project! :)

## ❓ Questions

You can join the Vapor [slack](http://vapor.team). Or you can create an issue on GitHub.

## ⭐ License

This project was released under the [MIT](license) license.
