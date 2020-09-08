# table-ios-sdk
An iOS SDK for [TABLE.co](https://table.co)

# Installation Guide

1. Instalation using CocoaPods:

   CocoaPods is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate TableSDK into your Xcode project using CocoaPods, specify it in your Podfile:
          
       pod 'TableSDK', '~> 0.1'

1. Import and initialise the SDK

```swift
import TableSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
          
        Table.initialize(workspaceUrl: "https://YOUR_WORKSPACE.table.co", apiKey: "YOUR_SDK_API_KEY", onSuccessInitializeCompletion: {
            //handle success
        }) { (errorCode, errorMessage) in
            //handle error
        }
    }
}
//...rest of your file...
```
Your SDK API key can be found in the Organization Settings section of your Workspace.

# Usage
   You'll need to call either `Table.registerUnidentifiedUser()` or `Table.registerUser()` before calling methods that require user information such as `Table.showConversationList()`.

### Register a Logged In user
```swift
var userAttributes = UserAttributes()
userAttributes.firstName = "Name"
userAttributes.lastName = "LastName"
userAttributes.email = "email@email.com"
Table.registerUser(withUserId: "USER_ID", userAttributes: userAttributes, onSuccessLoginCompletion: { 
    //handle success
}) { (errorCode, errorMessage) in
    //handle error
}
```

### Register an Unidentified user anonymously
```swift
Table.registerUnidentifiedUser(onSuccessLoginCompletion: {
    //handle success
}) { (errorCode, errorMessage) in
    //handle error
}
```

### Sign Out
```swift
Table.logout()  
```

### Show the Table conversation list to the user
```swift
Table.showConversationList(parentViewController: self) { (errorCode, errorMessage) in
    //handle error
}
```

# Push Notifications

## IOS Push Notifications
We use push notifications via APNS. How to setup your project for using push notifications you can find [here](https://developer.apple.com/documentation/usernotifications/registering_your_app_with_apns). 

### APNS Token
To start receiving iOS Push Notifications from your Table conversations, you will need to pass the APNS Token the above package gives you to this function:
```swift
Table.updateNotificationToken(token: token)
```

### Checking for Table Message
To check that the push notification you are getting is a Table message, you should handle UNNotificationResponse in the function of UNUserNotificationCenterDelegate and use Table.showConversationList() and tableId (tableId is the conversation ID that the message came from) here:
```swift
func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
       
       let userInfo = response.notification.request.content.userInfo
       if let tableId = userInfo["table_id"] as? String {
           if let rootViewController = self.window?.rootViewController as? UINavigationController {
               Table.showConversationList(parentViewController: rootViewController, tableId: tableId) { (errorCode, errorMessage) in
                   //handle error
               }
           }
       }
       print(userInfo)
       completionHandler()
   }
```
