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
    override func viewDidLoad() {
        
        super.viewDidLoad()

    
    jitsiMeetView?.delegate = self

    let options = JitsiMeetConferenceOptions.fromBuilder({ builder in
        builder.serverURL = URL(string: "https://meet.jit.si")
        builder.room = "ForwardIntakesInvokeBesides"
        builder.audioOnly = true
    })

    jitsiMeetView?.join(options)
}
}
