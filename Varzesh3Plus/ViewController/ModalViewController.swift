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
    var document: Document = Document.init("")
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var txtNewsNumber: UILabel!
    @IBOutlet weak var txtDescription: UILabel!
    @IBOutlet weak var webView: WKWebView!
    var strDescription : String?
    var link : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        getFromLink(link: link ?? "")
        txtTitle.textColor = UIColor.cyan
        
    }
    

    fileprivate func getFromLink(link : String )  {
        // Then back to the Main thread to update the UI.
        DispatchQueue.main.async {
            let link1 = link.split(separator: "/")
            var linkForShow = ""
            for text in (link1.enumerated()) {
                if text.offset == 4 {
                    
                }
                else if text.offset == 0{
                    linkForShow = linkForShow + text.element + "//"
                    
                }else {
                    linkForShow = linkForShow + text.element + "/"
                }
            }
            linkForShow.removeLast()
            
            print(linkForShow.prefix(5))
            if linkForShow.prefix(5) == "http:"{
                linkForShow.removeFirst(4)
                linkForShow = "https" + linkForShow
            }
            print(linkForShow)
            self.downloadHTML(urlString: linkForShow, cssString: ".news-page--news-text,[property=og:image],.news-page--news-title, .news-page--news-lead ,.news-page--news-info ")
//            self.downloadHTML(urlString: linkForShow, cssString: ".news-page--news-text,[property=og:image],.news-page--news-title,.news-page--news-info")
                //                    [property=og:image]
                //                    .news-page--news-text,
               
        }
        
    }
    
}
