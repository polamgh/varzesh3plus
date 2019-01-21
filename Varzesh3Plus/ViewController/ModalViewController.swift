//
//  ModalViewController.swift
//  Varzesh3Plus
//
//  Created by Ali Ghanavati on 10/27/1397 AP.
//  Copyright © 1397 AP Ali Ghanavati. All rights reserved.
//

import UIKit
import SwiftSoup
import WebKit

class ModalViewController: UIViewController , WKNavigationDelegate {
    
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var txtNewsNumber: UILabel!
    @IBOutlet weak var txtDescription: UILabel!
    @IBOutlet weak var webView: WKWebView!
    var modelParseCss : ModelParseCss?
    var link : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        self.title = "شرح"
        showNews()
        
    }
    
    @IBAction func btnShare(_ sender: Any) {
        
        let textToShare = [(link ?? "") + "\n اشتراک گذاری شده از طریق نرم افزار ورزش سه پلاس"]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    fileprivate func showNews() {
        self.txtTitle.text = modelParseCss?.title ?? ""
        self.txtNewsNumber.text = modelParseCss?.newsNumber ?? ""
        self.txtDescription.text = modelParseCss?.description ?? ""
        self.webView.loadHTMLString(modelParseCss?.newsHtml ?? "" , baseURL: nil)
        Loading.stop()
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        let css = " body { background-color : #ffffff ; color: #000000  ; direction: rtl ; display:inline-block ; font-size: 30px ; font-weight: bold; font-family: \"Shabnam-Bold-FD\"}"
        
        let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
        
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    
}
