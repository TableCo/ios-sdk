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

class JitsiVideoVC: UIViewController {
override func viewDidLoad() {
    super.viewDidLoad()

    let jitsiMeetView = view as? JitsiMeetView
    jitsiMeetView?.delegate = self

    let options = JitsiMeetConferenceOptions.fromBuilder({ builder in
        builder?.serverURL = URL(string: "https://meet.jit.si")
        builder?.room = "test123"
        builder?.audioOnly = true
    })

    jitsiMeetView?.join(options)
}
}
