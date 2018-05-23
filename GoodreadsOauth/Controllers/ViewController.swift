//
//  ViewController.swift
//  GoodreadsOauth
//
//  Created by Amal on 5/23/18.
//  Copyright © 2018 Amal. All rights reserved.
//

import UIKit
import OAuthSwift
import SafariServices

class ViewController:OAuthViewController {
    
    var oauthswift: OAuthSwift?
    lazy var internalWebViewController: WebViewController = {
        let controller = WebViewController()
        
        controller.view = UIView(frame: UIScreen.main.bounds) // needed if no nib or not loaded from storyboard
        controller.delegate = self
        controller.viewDidLoad() // allow WebViewController to use this ViewController as parent to be presented
        return controller
    }()
}

extension ViewController: OAuthWebViewControllerDelegate {
    
    func oauthWebViewControllerDidPresent() {
        
    }
    func oauthWebViewControllerDidDismiss() {
        
    }
    
    func oauthWebViewControllerWillAppear() {
        
    }
    func oauthWebViewControllerDidAppear() {
        
    }
    func oauthWebViewControllerWillDisappear() {
        
    }
    func oauthWebViewControllerDidDisappear() {
        // Ensure all listeners are removed if presented web view close
        oauthswift?.cancel()
    }
}

extension ViewController{
    
    
    
  
    
    // MARK: Goodreads
    func doOAuthGoodreads() {
        let oauthswift = OAuth1Swift(
            consumerKey:        "ByJPtxvVIlsWKlizEBbQ",
            consumerSecret:     "DizrvZRKwSyCz6B5NA8NEItcKwtuzTASGnvaXNxLVTs",
            requestTokenUrl:    "https://www.goodreads.com/oauth/request_token",
            authorizeUrl:       "https://www.goodreads.com/oauth/authorize?mobile=1",
            accessTokenUrl:     "https://www.goodreads.com/oauth/access_token"
        )
        self.oauthswift=oauthswift
        oauthswift.allowMissingOAuthVerifier = true
        /*if internalWebViewController.parent == nil {
         self.addChildViewController(internalWebViewController)
         }*/
        oauthswift.authorizeURLHandler = getURLHandler()//OAuthSwiftOpenURLExternally.sharedInstance
        let _ = oauthswift.authorize(
            withCallbackURL: URL(string: "oauth-swift://oauth-callback/goodreads")!,
            success: { credential, response, parameters in
                self.showTokenAlert(name: "", credential: credential)
                self.GoodreadsOauthGoodreads(oauthswift)
        },
            failure: { error in
                print(error.localizedDescription, terminator: "")
        }
        )
        
    }
    
    func GoodreadsOauthGoodreads(_ oauthswift: OAuth1Swift) {
        let _ = oauthswift.client.get(
            "https://www.goodreads.com/api/auth_user",
            success: { response in
                // Most Goodreads methods return XML, you'll need a way to parse it.
                let dataString = response.string!
                print(dataString)
        }, failure: { error in
            print(error)
        }
        )
    }
    
    // token alert
    func showTokenAlert(name: String?, credential: OAuthSwiftCredential) {
        var message = "oauth_token:\(credential.oauthToken)"
        if !credential.oauthTokenSecret.isEmpty {
            message += "\n\noauth_token_secret:\(credential.oauthTokenSecret)"
        }
        self.showAlertView(title: name ?? "Service", message: message)
    }
    
    func showAlertView(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func getURLHandler() -> OAuthSwiftURLHandlerType {
        if #available(iOS 9.0, *) {
            let handler = SafariURLHandler(viewController: self, oauthSwift: self.oauthswift!)
            handler.presentCompletion = {
                print("Safari presented")
            }
            handler.dismissCompletion = {
                print("Safari dismissed")
            }
            handler.factory = { url in
                let controller = SFSafariViewController(url: url)
                // Customize it, for instance
                if #available(iOS 10.0, *) {
                    // controller.preferredBarTintColor = UIColor.red
                }
                return controller
            }
            
            return handler
        }
        return OAuthSwiftOpenURLExternally.sharedInstance
    }
}



/*enum URLHandlerType {
 case `internal`
 case external
 }
 
 
 struct FormViewControllerData {
 var key: String
 var secret: String
 var handlerType: URLHandlerType
 }
 
 // Little utility class to wait on data
 class Semaphore<T> {
 let segueSemaphore = DispatchSemaphore(value: 0)
 var data: T?
 
 func waitData(timeout: DispatchTime? = nil) -> T? {
 if let timeout = timeout {
 let _ = segueSemaphore.wait(timeout: timeout) // wait user
 } else {
 segueSemaphore.wait()
 }
 return data
 }
 
 func publish(data: T) {
 self.data = data
 segueSemaphore.signal()
 }
 
 func cancel() {
 segueSemaphore.signal()
 }
 }*/


