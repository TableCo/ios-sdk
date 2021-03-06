//
//  ConversationVC.swift
//  Table
//
//  Created by acquaint on 10/01/20.
//  Copyright © 2020 acquaint. All rights reserved.
//

import UIKit
import WebKit

class ConversationVC: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet var btnCreate: UIButton!
    @IBOutlet var webViewContainer: UIView!
    @IBOutlet var btnBack: UIBarButtonItem!
    var webView: WKWebView!
    var tapTimer: Timer?
    private var viewModel = ConversationViewModel()
    var tableId = ""
    var isFromNotification = false
    private var canDissmissVC = true
    var webViewUrl = ""
    typealias CompletionHandler = (_ success: Bool) -> Void
    var initalLoad = true
    var initialBack = true

    override func viewDidLoad() {
        super.viewDidLoad()

        if let userToken = Table.instance.getToken() {
            webViewUrl = Table.instance.getWorkspaceUrl() + API.Loading + "&token=" + userToken
        }
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.setHidesBackButton(true, animated: false)

        title = "Loading"
        NotificationCenter.default.addObserver(self, selector: #selector(onDidHangupCall(_:)), name: Notification.Name("didHangupCall"), object: nil)
        if #available(iOS 12.0, *) {
            self.view.backgroundColor = traitCollection.userInterfaceStyle == .light ? UIColor.white : UIColor.white
        } else {
            // Fallback on earlier versions
        }

        setupWebView()

        createIntialConversation(completionHandler: { (success) -> Void in

            if success {
                let myURL = URL(string: self.webViewUrl)
                let myRequest = URLRequest(url: myURL!)
                self.webView.load(myRequest)
                self.initalLoad = true
                self.updateBackButtons()
            } else {
                if let userToken = Table.instance.getToken() {
                    self.webViewUrl = Table.instance.getWorkspaceUrl() + API.Conversation + "&token=" + userToken
                    let myURL = URL(string: self.webViewUrl)
                    let myRequest = URLRequest(url: myURL!)
                    self.webView.load(myRequest)
                }
            }
        })
    }

    @objc func onDidHangupCall(_ notification: Notification) {
        let js = "window.TableCommand('jitsi-hangup', 1);"
        webView.evaluateJavaScript(js)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkBackItems()
        setupCreateButton()
        setupNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tapTimer?.invalidate()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.checkLoggedIn { isLoggedIn in
            if !isLoggedIn {
                // Reset back to the first screen
                self.dismiss(animated: false, completion: nil)
            }
        }
    }

    // MARK: - Setup UI

    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func setupCreateButton() {
        btnCreate.layer.cornerRadius = btnCreate.layer.frame.height / 2
        btnCreate.clipsToBounds = true
        btnCreate.isHidden = true
    }

    func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        let contentController = WKUserContentController()

        guard let urlStr = BundleUtils.sdkBundle().url(forResource: "ajax", withExtension: "js") else {
            assert(false, "Should always get the ajax bundle")
            return
        }

        let ajaxScript = try? String(contentsOf: urlStr, encoding: .utf8)
        let ajaxHandler = WKUserScript(source: ajaxScript!, injectionTime: .atDocumentStart, forMainFrameOnly: false)

        contentController.addUserScript(ajaxHandler)
        contentController.add(self, name: "videocall")
        contentController.add(self, name: "jitsicall")
        contentController.add(self, name: "onLocationChange")
        
        webConfiguration.userContentController = contentController

        let customFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: 0.0, height: webViewContainer.frame.size.height))
        webView = WKWebView(frame: customFrame, configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webViewContainer.addSubview(webView)

        webView.topAnchor.constraint(equalTo: webViewContainer.topAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: webViewContainer.rightAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: webViewContainer.leftAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: webViewContainer.bottomAnchor).isActive = true
        webView.heightAnchor.constraint(equalTo: webViewContainer.heightAnchor).isActive = true
        webView.uiDelegate = self
        webView.navigationDelegate = self

        let myURL = URL(string: webViewUrl)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

    // MARK: - Initial Load

    func createIntialConversation(completionHandler: @escaping CompletionHandler) {
        var myURL = ""
        let experienceShortCode = Table.instance.getUserExperienceShortCode()
        viewModel.tryGetTable(experienceShortCode: experienceShortCode)
        viewModel.getTableSuccess = { tableID in
            guard let tableID = tableID else { return }
            myURL = Table.instance.getWorkspaceUrl() + "/conversation/" + tableID
            self.webViewUrl = myURL
            completionHandler(true)
        }

        viewModel.getTableFailed = { _ in
            completionHandler(false)
        }
    }

    // MARK: - Button Action

    @IBAction func newConversationClick(_ sender: Any) {
        let experienceShortCode = Table.instance.getUserExperienceShortCode()
        viewModel.tryCreateConversation(experienceShortCode: experienceShortCode)
        viewModel.createConversationSuccess = { conversationId in
            guard let conversationId = conversationId else { return }
            let myURL = URL(string: Table.instance.getWorkspaceUrl() + "/conversation/" + conversationId)
            let myRequest = URLRequest(url: myURL!)

            if !Thread.isMainThread {
                DispatchQueue.main.async { [weak self] in
                    self?.webView.load(myRequest)
                }
            } else {
                self.webView.load(myRequest)
            }
        }

        viewModel.createConversationFailed = { _ in
        }
    }

    @IBAction func btnBackClick(_ sender: Any) {
        if initialBack {
            if let userToken = Table.instance.getToken() {
                webViewUrl = Table.instance.getWorkspaceUrl() + API.Conversation + "&token=" + userToken
                let myURL = URL(string: webViewUrl)
                let myRequest = URLRequest(url: myURL!)
                webView.load(myRequest)
            }
            initialBack = false
        } else if canDissmissVC {
            dismiss(animated: false, completion: nil)
        } else if webView.canGoBack {
            webView.goBack()
        }
        checkBackItems()
    }

    // MARK: - Helper Functions

    func checkBackItems() {
        tapTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            self.tapTimer?.invalidate()
            self.updateBackButtons()
        })
    }

    func updateBackButtons() {
        DispatchQueue.main.async { [self] in

            if webView.canGoBack || self.initalLoad {
                let allConversationsURL = Table.instance.getWorkspaceUrl() + API.Conversation + "&token=" + (Table.instance.getToken() ?? "")
                if let currentURL = webView.url?.absoluteString {
                    print(currentURL)
                    viewModel.getConversationTitle(url: currentURL) { title in
                        if !Thread.isMainThread {
                            DispatchQueue.main.async { [weak self] in
                                if let title = title {
                                    self?.title = title
                                } else {
                                    self?.title = "Conversation"
                                }
                            }
                        } else {
                            if let title = title {
                                self.title = title
                            } else {
                                self.title = "Conversation"
                            }
                        }
                    }
                    if currentURL == allConversationsURL {
                        btnCreate.isHidden = false
                        canDissmissVC = true
                        self.title = "All Conversations"
                        
                        

                    }
                    else{
                        btnCreate.isHidden = true
                        canDissmissVC = false
                    }
                }
                //   btnBack.isHidden = false

                tapTimer?.invalidate()
                self.initalLoad = false
            }
            
        }
    }
}

// MARK: - Webview Delegates

extension ConversationVC: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.updateBackButtons()
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        webView.evaluateJavaScript(javaScript) { (_, err) in
        if isFromNotification {
            let myURL = URL(string: Table.instance.getWorkspaceUrl() + "/conversation/" + tableId)
            let myRequest = URLRequest(url: myURL!)
            self.webView.load(myRequest)
            isFromNotification = false
        }
        NSObject.load()

//        }

        //       APIManager.shared.hideIndicator()
       
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.async {
            //      APIManager.shared.hideIndicator()
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
      
        if navigationAction.navigationType == .linkActivated {
            if let url = navigationAction.request.url, UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
            }
        } else {
            decisionHandler(.allow)
        }
        updateBackButtons()
       
    }
}

// MARK: - Webview Script Handler

extension ConversationVC: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "videocall" {
            if !isCallStarted {
                let vc = VideoVC.instantiateFromAppStoryBoard(appStoryBorad: .TableMainBoard)
                if let data = message.body as? [String: Any] {
                    guard let sessionId = data["sessionId"] as? String else {
                        showAlert("", message: "SessionId not found")
                        return
                    }
                    guard let token = data["token"] as? String else {
                        showAlert("", message: "Token not found")
                        return
                    }
                    vc.kSessionId = sessionId
                    vc.kToken = token
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        else if message.name == "jitsicall"{
                    if !isCallStarted{
                        let vc = JitsiVideoVC.instantiateFromAppStoryBoard(appStoryBorad: .TableMainBoard)
                        if let data = message.body as? [String:Any]{
                            guard let server = data["server"] as? String else {
                                self.showAlert("", message: "Server not found")
                                return
                            }
                            guard let tenant = data["tenant"] as? String else {
                                self.showAlert("", message: "Tenant not found")
                                return
                            }
                            guard let roomID = data["roomID"] as? String else {
                                self.showAlert("", message: "RoomID not found")
                                return
                            }
                            guard let jwt = data["jwt"] as? String else {
                                self.showAlert("", message: "Token not found")
                                return
                            }
                            let userInfo = Table.getUserInfo()
                            vc.userInfo = userInfo
                            vc.server = server
                            vc.tenant = tenant
                            vc.roomID = roomID
                            vc.token = jwt
                            navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
        else if message.name == "onLocationChange"{
            updateBackButtons()
        }

    }
}
