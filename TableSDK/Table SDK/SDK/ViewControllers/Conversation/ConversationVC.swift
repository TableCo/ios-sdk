//
//  ConversationVC.swift
//  Table
//
//  Created by acquaint on 10/01/20.
//  Copyright © 2020 acquaint. All rights reserved.
//

import UIKit
import WebKit

class ConversationVC: UIViewController,UIGestureRecognizerDelegate {
    @IBOutlet weak var btnCreate: UIButton!
    
    @IBOutlet weak var webViewContainer: UIView!
    @IBOutlet weak var btnBack: UIBarButtonItem!
    var webView: WKWebView!
    var tapTimer: Timer?
    private var viewModel = ConversationViewModel()
    var tableId = ""
    var isFromNotification = false
    private var canDissmissVC = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.setHidesBackButton(true, animated: false)
        self.title = "All Conversations"
     //   btnBack.isHidden = true
        
        if #available(iOS 12.0, *) {
            self.view.backgroundColor = traitCollection.userInterfaceStyle == .light ? UIColor.white : UIColor.white
        } else {
            // Fallback on earlier versions
        }
        setupWebView()
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
        
        viewModel.checkLoggedIn { (isLoggedIn) in
            if (!isLoggedIn) {
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
        
        guard let urlStr = Bundle(identifier: "Table.co.Table-SDK")?.url(forResource: "ajax", withExtension: "js") else {
            assert(false, "Should always get the ajax bundle")
            return
        }
        
        let ajaxScript = try? String(contentsOf: urlStr, encoding: .utf8)
        let ajaxHandler = WKUserScript(source: ajaxScript!, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        
        contentController.addUserScript(ajaxHandler)
        contentController.add(self, name: "videocall")
        webConfiguration.userContentController = contentController
        
        let customFrame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 0.0, height: self.webViewContainer.frame.size.height))
        self.webView = WKWebView (frame: customFrame , configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.webViewContainer.addSubview(webView)
        
        webView.topAnchor.constraint(equalTo: webViewContainer.topAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: webViewContainer.rightAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: webViewContainer.leftAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: webViewContainer.bottomAnchor).isActive = true
        webView.heightAnchor.constraint(equalTo: webViewContainer.heightAnchor).isActive = true
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        if let userToken = Table.instance.getToken() {
            let myURL = URL(string: Table.instance.getWorkspaceUrl() + API.Conversation + "&token=" + userToken)
            let myRequest = URLRequest(url: myURL!)
            self.webView.load(myRequest)
        } else {
            let myURL = URL(string: Table.instance.getWorkspaceUrl() + API.Conversation)
            let myRequest = URLRequest(url: myURL!)
            self.webView.load(myRequest)
        }
    }
    
    // MARK: - Button Action
    @IBAction func newConversationClick(_ sender: Any) {
        let experienceShortCode = Table.instance.getUserExperienceShortCode()
        viewModel.tryCreateConversation(experienceShortCode: experienceShortCode)
        viewModel.createConversationSuccess = {(conversationId) in
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
        
        viewModel.createConversationFailed = {(error) in
            
        }
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        if webView.canGoBack {
            webView.goBack()
        } else if canDissmissVC {
            dismiss(animated: false, completion: nil)
        }
        checkBackItems()
    }
    
    // MARK: - Helper Functions
    func checkBackItems()  {
        tapTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
            self.tapTimer?.invalidate()
            self.updateBackButtons()
        })
    }
    
    func updateBackButtons() {
        if webView.canGoBack {
            if let currentURL = webView.url?.absoluteString{
                print(currentURL)
                viewModel.getConversationTitle(url: currentURL) { (title) in
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
            }
         //   btnBack.isHidden = false
            canDissmissVC = false
            btnCreate.isHidden = true
            tapTimer?.invalidate()
        }else{
            self.title = "All Conversations"
         //   btnBack.isHidden = true
            canDissmissVC = true
            btnCreate.isHidden = false
            checkBackItems()
        }
    }
}

// MARK: - Webview Delegates
extension ConversationVC: WKUIDelegate, WKNavigationDelegate{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        DispatchQueue.main.async {
        //    APIManager.shared.showIndicator()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        webView.evaluateJavaScript(javaScript) { (_, err) in
        if self.isFromNotification {
            let myURL = URL(string: Table.instance.getWorkspaceUrl() + "/conversation/" + self.tableId)
            let myRequest = URLRequest(url: myURL!)
            self.webView.load(myRequest)
            self.isFromNotification = false
        }
        NSObject.self.load()
        
//        }
        DispatchQueue.main.async {
     //       APIManager.shared.hideIndicator()
            self.checkBackItems()
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.async {
      //      APIManager.shared.hideIndicator()
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url, UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
            }
        } else {
            decisionHandler(.allow)
        }
    }
}

// MARK: - Webview Script Handler
extension ConversationVC: WKScriptMessageHandler{
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "videocall"{
            if !isCallStarted{
                let vc = VideoVC.instantiateFromAppStoryBoard(appStoryBorad: .TableMainBoard)
                if let data = message.body as? [String:Any]{
                    guard let sessionId = data["sessionId"] as? String else {
                        self.showAlert("", message: "SessionId not found")
                        return
                    }
                    guard let token = data["token"] as? String else {
                        self.showAlert("", message: "Token not found")
                        return
                    }
                    vc.kSessionId = sessionId
                    vc.kToken = token
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    
}
