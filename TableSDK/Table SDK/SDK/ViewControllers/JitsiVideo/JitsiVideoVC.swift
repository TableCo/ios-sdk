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

class JitsiVideoVC: UIViewController, JitsiMeetViewDelegate {
    @IBOutlet var jitsiMeetView: JitsiMeetView!
    var tenant = ""
    var roomID = ""
    var token = ""
    var userInfo: UserAttributes = UserAttributes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tokenizedURL = self.tenant + "/" + self.roomID + "?jwt=" + self.token
        print(tokenizedURL)

     
    
    jitsiMeetView?.delegate = self

    let options = JitsiMeetConferenceOptions.fromBuilder({ builder in
        builder.serverURL = URL(string: tokenizedURL)
        builder.userInfo = JitsiMeetUserInfo(displayName: self.userInfo.firstName, andEmail: self.userInfo.email, andAvatar: URL(string: ""))
        builder.setFeatureFlag("invite.enabled", withBoolean: false)
        
    })

    jitsiMeetView?.join(options)
}
}
