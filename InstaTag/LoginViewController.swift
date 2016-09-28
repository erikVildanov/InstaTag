//
//  LoginViewController.swift
//  InstaTag
//
//  Created by Эрик Вильданов on 24.09.16.
//  Copyright © 2016 ErikVildanov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIWebViewDelegate {

    let loginView = LoginView()
    let instaAPI = InstaAPI()
    var boxView = ActivityView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.webView.delegate = self
        view = loginView
        navigationItem.hidesBackButton = true
        navigationItem.title = "LogIn Instagram"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Reachability.connectedToNetwork() == true{
        let urlString = instaAPI.kBaseURL.appendingFormat(instaAPI.kAuthenticationURL, instaAPI.kClientID, instaAPI.kRedirectURI)
        let request = NSURLRequest(url: NSURL(string: urlString) as! URL)
        loginView.webView.loadRequest(request as URLRequest)
        } else {
            print("Internet connection FAILED")
            let alert = UIAlertController(title: "Соединение не установлено", message: "Продолжить просмотр избранного в оффлайне?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Продолжить", style: UIAlertActionStyle.default, handler: exitApp ))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func exitApp(alert: UIAlertAction!){
        let collectionViewController = CollectionViewController()
        collectionViewController.flag = true
        self.navigationController?.pushViewController(collectionViewController, animated: false)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlString: NSString = request.url!.absoluteString as NSString
        let url: NSURL = request.url! as URL as NSURL
        let urlParts = url.pathComponents
        
        if urlParts?.count == 1 {
            let tokenParam: NSRange = urlString.range(of: instaAPI.kAccessToken)
            if tokenParam.location != NSNotFound {
                
                var token: NSString = urlString.substring(from: NSMaxRange(tokenParam)) as NSString
                
                let endRange: NSRange = token.range(of: "&")
                
                if endRange.location != NSNotFound {
                    token = token.substring(to: endRange.location) as NSString
                }
                
                if token.length > 0 {
                    let collectionViewController = CollectionViewController()
                    collectionViewController.modalTransitionStyle = .crossDissolve
                    self.navigationController?.pushViewController(collectionViewController, animated: false)
                }
            }
            
        }
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        boxView.frame = view.frame
        view.addSubview(boxView)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        boxView.removeFromSuperview()
    }
}
