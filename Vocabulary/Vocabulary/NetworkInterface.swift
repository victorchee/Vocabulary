//
//  NetworkInterface.swift
//  Vocabulary
//
//  Created by qihaijun on 11/10/15.
//  Copyright © 2015 VictorChee. All rights reserved.
//

/**
Token传递方式
1.设置HTTP header， 格式为Authorization: Bearer TOKEN
2.在query string里传递，https://api.shanbay.com/endpoint/?access_token=TOKEN
3.在post请求的body里传递
*/

import UIKit

class NetworkInterface: NSObject, NSURLSessionDelegate {
    let user = UserInfo.currentUser
    
    var session: NSURLSession {
        get {
            let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            return NSURLSession(configuration: configuration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        }
    }
    
    /**
        返回的是一个web授权页
     */
    func authorize() {
        let link = "https://api.shanbay.com/oauth2/authorize/?client_id=\(user.appKey)&client_secret=\(user.appSecret)&response_type=code&state=123"
        guard let url = NSURL(string: link) else {
            return
        }
        let task = session.dataTaskWithURL(url) { (data, response, error) -> Void in
            print(response)
            guard let data = data else {
                print(error)
                return
            }
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
                print(json)
            } catch _ {
                print("JSON serialization failed")
            }
            
            let temp = NSString(data: data, encoding: NSUTF8StringEncoding)
            print(temp)
        }
        task.resume()
    }
    
    /**
     返回
     {
     "access_token": "m4sprK03EG5Cs6iqyZNTSnPKRDe0M5",
     "token_type": "Bearer",
     "expires_in": 36000,
     "refresh_token": "ydaIL025K2VnZCAguxNOU39NMtx8hf",
     "scope": "read write"
     }
     */
    func getToken(code: String) {
        let link = "https://api.shanbay.com/oauth2/token/"
        guard let url = NSURL(string: link) else {
            return
        }
        let data = ["client_id":user.appKey,
                    "client_secret":user.appSecret,
                    "grant_type":"authorization_code",
                    "code":code,
                    "redirect_uri":user.redirectURL]
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        do {
            try request.HTTPBody = NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions(rawValue: 0))
        } catch _ {
            
        }
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            print(response)
            guard let data = data else {
                print(error)
                return
            }
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
                print(json)
            } catch _ {
                print("JSON serialization failed")
            }
            
            let temp = NSString(data: data, encoding: NSUTF8StringEncoding)
            print(temp)
        }
        task.resume()
    }
    
    func getUserInfo() {
        let link = "https://api.shanbay.com/account/?access_token=lXK36BPdQW5e3nV6SMh2NLOS6LJxXK"
        guard let url = NSURL(string: link) else {
            return
        }
        let task = session.dataTaskWithURL(url) { (data, response, error) -> Void in
            print(response)
            guard let data = data else {
                print(error)
                return
            }
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
                print(json)
            } catch _ {
                print("JSON serialization failed")
            }
            
            let temp = NSString(data: data, encoding: NSUTF8StringEncoding)
            print(temp)
        }
        task.resume()
    }
    
    // MARK: - NSURLSessionDelegate
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!))
    }
}
