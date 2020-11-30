//
//  JitsiVideoVC.swift
//  Table SDK
//
//  Created by Afify on 04/11/2020.
//  Copyright © 2020 TableCO. All rights reserved.
//

import Foundation
import UIKit
import JitsiMeet

class JitsiVideoVC: UIViewController  {
    @IBOutlet var jitsiMeetView: JitsiMeetView!
    var server = ""
    var tenant = ""
    var roomID = ""
    var token = ""
    var email = ""
    var userID = ""
    var userInfo: UserAttributes = UserAttributes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        let tokenizedURL = "https://" + self.server + "/" + self.tenant + "/" + self.roomID + "?jwt=" + self.token
        print(tokenizedURL)
        
        email = self.userInfo.email ?? ""
        userID = self.userInfo.userHash ?? "anonymous"
      
        if (email == nil) || email.isEmpty {
            email = "guest-user-" + userID + "@table.invalid"
        }
        
    jitsiMeetView?.delegate = self

    let options = JitsiMeetConferenceOptions.fromBuilder({ builder in
        builder.room = tokenizedURL
        builder.userInfo = JitsiMeetUserInfo(displayName: self.userInfo.firstName, andEmail: self.email, andAvatar: URL(string: ""))
        builder.setFeatureFlag("invite.enabled", withBoolean: false)
        
    })

    jitsiMeetView?.join(options)
}
    
}
extension JitsiVideoVC: JitsiMeetViewDelegate {
    func conferenceTerminated(_ data: [AnyHashable : Any]!) {
        navigationController?.popViewController(animated: true)    }
}
