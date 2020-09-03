//
//  VideoVC.swift
//  Table
//
//  Created by acquaint on 22/01/20.
//  Copyright © 2020 acquaint. All rights reserved.
//

import UIKit
import OpenTok

class VideoVC: UIViewController {

    var kApiKey = "46053512"
    var kSessionId: String = ""
    var kToken: String = ""
    var session: OTSession?
    var publisher: OTPublisher?
    var subscriber: OTSubscriber?
    var viewModel = VideoViewModel()

    @IBOutlet weak var btnChangeCamera: UIButton!
    @IBOutlet weak var btnEndCall: UIButton!
    @IBOutlet weak var lblFlipCamera: UILabel!
    @IBOutlet weak var lblEndCall: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
       // navigationController?.isNavigationBarHidden = true
        isCallStarted = true
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        checkCameraPermission()
    }

    override func viewWillDisappear(_ animated: Bool) {
        isCallStarted = false
    }

    // MARK: - setup UI
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setupUI() {
        lblFlipCamera.font = UIFont.systemFont(ofSize: _lblFontSize)
        lblEndCall.font = UIFont.systemFont(ofSize: _lblFontSize)
        setupNavigationBar()
    }
    
    func getOpenTokAPI(){
        viewModel.getOpenTokKey()
        viewModel.getOpenTokenSuccess = {(apiKey) in
            guard let apiKey = apiKey else { return }
            self.kApiKey = apiKey
            self.checkMicroPhonePermission()
            self.session = OTSession(apiKey: self.kApiKey, sessionId: self.kSessionId, delegate: self)
            var error: OTError?
            self.session?.connect(withToken: self.kToken, error: &error)
        }
        
        viewModel.getOpenTokenFailed = {(error) in
            if error != nil {
                print(error!)
                self.showError(error: error)
            }
        }
        
    }


    // MARK: - Button Action
    @IBAction func btnEndCallClick(_ sender: Any) {
        finishCall()
    }

    @IBAction func btnChangeCameraClick(_ sender: Any) {
        if publisher != nil {
            if publisher?.cameraPosition == .back {
                publisher?.cameraPosition = .front
            }else{
                publisher?.cameraPosition = .back
            }
        }
    }

    // MARK: - Video Helper Functions
    func connectToAnOpenTokSession() {
        getOpenTokAPI()

    }

    func finishCall() {
        var error: OTError?
        session?.disconnect(&error)
        if error != nil {
            print(error!)
          //  CLSLogv("Call end Error %@", getVaList([error!.localizedDescription]))
            showError(error: error)
        }else{
            navigationController?.popViewController(animated: true)
        }
    }

    func showError(error: Error?) {
        if let err = error{
            self.showAlert("", message: err.localizedDescription)
        }
    }

    fileprivate func cleanupSubscriber() {
        subscriber?.view?.removeFromSuperview()
        subscriber = nil
    }

    fileprivate func cleanupPublisher() {
        publisher?.view?.removeFromSuperview()
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}

// MARK: - OTSessionDelegate callbacks
extension VideoVC: OTSessionDelegate{
    func sessionDidConnect(_ session: OTSession) {
        print("The client connected to the OpenTok session.")

        let settings = OTPublisherSettings()
        settings.name = UIDevice.current.name
        guard let publishr = OTPublisher(delegate: self, settings: settings) else {
            return
        }

        var error: OTError?
        session.publish(publishr, error: &error)
        guard error == nil else {
            print(error!)
         //   CLSLogv("Publish Error %@", getVaList([error!.localizedDescription]))
            return
        }
        publisher = publishr
        guard let publisherView = publishr.view else {
            return
        }
        let yPos = 6//Common.getStatusBarHeight() + 6
        publisherView.frame = CGRect(x: 16, y: yPos, width: 90, height: 120)
        publisherView.backgroundColor = .red
        view.addSubview(publisherView)
    }

    func sessionDidDisconnect(_ session: OTSession) {
        print("The client disconnected from the OpenTok session.")
    }

    func session(_ session: OTSession, didFailWithError error: OTError) {
        print("The client failed to connect to the OpenTok session: \(error).")
   //     CLSLogv("Session Error %@", getVaList([error.localizedDescription]))
    }

    func session(_ session: OTSession, streamCreated stream: OTStream) {
        print("A stream was created in the session.")

        subscriber = OTSubscriber(stream: stream, delegate: self)
        guard let subscriber = subscriber else {
            return
        }

        var error: OTError?
        session.subscribe(subscriber, error: &error)
        guard error == nil else {
            print(error!)
   //         CLSLogv("Session subscribe Error %@", getVaList([error!.localizedDescription]))
            return
        }

        guard let subscriberView = subscriber.view else {
            return
        }
        subscriberView.frame = UIScreen.main.bounds
        view.insertSubview(subscriberView, at: 0)
    }

    func session(_ session: OTSession, streamDestroyed stream: OTStream) {
        print("A stream was destroyed in the session.")
        if let subStream = subscriber?.stream, subStream.streamId == stream.streamId {
            cleanupSubscriber()
        }
        finishCall()

    }
}

// MARK: - OTPublisherDelegate callbacks
extension VideoVC: OTPublisherDelegate {
    func publisher(_ publisher: OTPublisherKit, streamCreated stream: OTStream) {
        print("Publishing")
    }

    func publisher(_ publisher: OTPublisherKit, didFailWithError error: OTError) {
        print("The publisher failed: \(error)")
     //   CLSLogv("Publisher Error %@", getVaList([error.localizedDescription]))
    }

    func publisher(_ publisher: OTPublisherKit, streamDestroyed stream: OTStream) {
        cleanupPublisher()
        if let subStream = subscriber?.stream, subStream.streamId == stream.streamId {
            cleanupSubscriber()
        }
    }
}

// MARK: - OTSubscriberDelegate callbacks
extension VideoVC: OTSubscriberDelegate {
    public func subscriberDidConnect(toStream subscriber: OTSubscriberKit) {
        print("The subscriber did connect to the stream.")
    }

    public func subscriber(_ subscriber: OTSubscriberKit, didFailWithError error: OTError) {
        print("The subscriber failed to connect to the stream.")
    }
}

// MARK: - Camera & Mic Permission Helper
extension VideoVC {

    func checkCameraPermission(){
        let status = AVCaptureDevice.authorizationStatus(for: .video)

        switch status {
        case .notDetermined: requestCameraPermission()
        case .authorized: connectToAnOpenTokSession()
        case .restricted, .denied: alertCameraAccessNeeded()
        @unknown default:
            print("Not Determined")
        }
    }

    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            guard accessGranted == true else {
                self.showAlert("", message: Message.Permission.cameraAccess)
                self.navigationController?.popViewController(animated: true)
                return
            }
            self.connectToAnOpenTokSession()
        })
    }

    func alertCameraAccessNeeded() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        let alert = UIAlertController( title: "", message: Message.Permission.cameraSetting, preferredStyle: .alert )
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        }))
        present(alert, animated: true, completion: nil)
    }

    func checkMicroPhonePermission() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSessionRecordPermission.granted:
            print("Permission granted")
        case AVAudioSessionRecordPermission.denied:
            self.showAlert("", message: Message.Permission.micAccess)
        case AVAudioSessionRecordPermission.undetermined:
            print("Request permission here")
            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                // Handle granted
            })
        @unknown default:
            print("No Detected")
        }
    }
}
