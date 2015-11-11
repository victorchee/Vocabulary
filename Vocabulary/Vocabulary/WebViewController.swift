//
//  WebViewController.swift
//  Vocabulary
//
//  Created by qihaijun on 11/10/15.
//  Copyright © 2015 VictorChee. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    
    let user = UserInfo.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let link = "https://api.shanbay.com/oauth2/authorize/?client_id=\(user.appKey)&response_type=token&redirect_uri=\(user.redirectURL)"
        if let url = NSURL(string: link) {
            let request = NSURLRequest(URL: url)
            webView.loadRequest(request)
        }
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print(request.URL)
        if let link = request.URL?.absoluteString {
            if link.hasPrefix(user.redirectURL) {
                if let index = link.rangeOfString("#")?.endIndex {
                    let parametersString = link.substringFromIndex(index)
                    let parameters = parametersString.characters.split("&").map(String.init)
                    var parametersDictionary = [String:String]()
                    for param in parameters {
                        let keyValue = param.characters.split("=").map(String.init)
                        if keyValue.count == 2 {
                            parametersDictionary[keyValue.first!] = keyValue.last
                        }
                    }
                    user.accessToken = parametersDictionary["access_token"]
                    user.tokenType = parametersDictionary["token_type"]
                    user.tokenExpires = parametersDictionary["expires_in"]
                    user.tokenScope = parametersDictionary["scope"]
                }
                delay(0.25) {
                    self.navigationController?.popViewControllerAnimated(true)
                }
                return false
            }
        }
        return true
    }
}
