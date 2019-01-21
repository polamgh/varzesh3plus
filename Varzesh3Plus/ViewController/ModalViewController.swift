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
    var strDescription : String?
    var link : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        
        NewsParse().getDataFromLink(link: link ?? "") { (modelParseCss, error) in
            self.txtTitle.text = modelParseCss?.title ?? ""
            self.txtNewsNumber.text = modelParseCss?.newsNumber ?? ""
            self.txtDescription.text = modelParseCss?.description ?? ""
            self.webView.loadHTMLString(modelParseCss?.newsHtml ?? "" , baseURL: nil)
        }
        
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Loading.stop()
        let css = " body { background-color : #ffffff ; color: #000000  ; direction: rtl ; display:inline-block ; font-size: 30px ; font-weight: bold; font-family: \"Shabnam-Bold-FD\"}"
        
        let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
        
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    
}
