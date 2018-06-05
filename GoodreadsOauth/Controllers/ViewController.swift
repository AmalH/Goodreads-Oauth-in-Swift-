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
import SWXMLHash

class ViewController:OAuthViewController {
    
    var oauthswift: OAuthSwift?
   
    @IBAction func goodReadsAuthActiob(_ sender: Any) {
        doOAuthGoodreads()
    }
    
    func doOAuthGoodreads() {
        
        /** create an instance of oauth1 **/
        let oauthswift = OAuth1Swift(
            consumerKey:        "your-api-key-here",
            consumerSecret:     "your-api-secret-here",
            requestTokenUrl:    "https://www.goodreads.com/oauth/request_token",
            authorizeUrl:       "https://www.goodreads.com/oauth/authorize?mobile=1",
            accessTokenUrl:     "https://www.goodreads.com/oauth/access_token"
        )
        self.oauthswift=oauthswift
        oauthswift.allowMissingOAuthVerifier = true
        oauthswift.authorizeURLHandler = getURLHandler()
        
        /** authorize **/
        let _ = oauthswift.authorize(
            withCallbackURL: URL(string: "OAuthSample://oauth-callback/goodreads")!,
            success: { credential, response, parameters in
                self.showTokenAlert(name: "Oauth Credentials", credential:  credential)
                self.testOauthGoodreads(oauthswift)
        },
            failure: { error in
                print( "ERROR ERROR: \(error.localizedDescription)", terminator: "")
        }
        )
    }
    
    func testOauthGoodreads(_ oauthswift: OAuth1Swift) {
        let _ = oauthswift.client.get(
            "https://www.goodreads.com/api/auth_user",
            success: { response in
                
                /** parse the returned xml to read user id **/
                let dataString = response.string!
                let xml = SWXMLHash.parse(dataString)
                let userID  =  (xml["GoodreadsResponse"]["user"].element?.attribute(by: "id")?.text)!
                print("---- RAW:\(dataString)")
                print("---- XML:\(xml)")
                print("---- USER ID:\(userID)")
                self.showAlertView(title: "ID of authorised user", message:  "user_id:\(userID). You can now use it for Goodreads API rest calls..")
                
                /** save the userID to .. **/
                // ...
                
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
            /* handler.presentCompletion = {
             print("Safari presented")
             }
             handler.dismissCompletion = {
             print("Safari dismissed")
             }*/
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

