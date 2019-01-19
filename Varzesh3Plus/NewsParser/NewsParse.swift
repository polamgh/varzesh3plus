//
//  NewsParse.swift
//  Varzesh3+
//
//  Created by Macintosh on 7/25/1397 AP.
//  Copyright © 1397 ali. All rights reserved.
//

import Foundation
import SwiftSoup
import UIKit
import WebKit

extension ModalViewController {
    func downloadHTML(urlString : String , cssString : String ) {
        guard let url = URL(string: urlString) else {
            // an error occurred
            UIAlertController.showAlert("Error: \(urlString) doesn't seem to be a valid URL", self)
            return
        }
        
        do {
            // content of url
            let html = try String.init(contentsOf: url)
            // parse it into a Document
            document = try SwiftSoup.parse(html)
            // parse css query
            parse(CSSText: cssString)
        } catch let error {
            // an error occurred
            UIAlertController.showAlert("Error: \(error)", self)
        }
        
    }
    
    func parse(CSSText : String)  {
        do {
            
            // firn css selector
            let elements: Elements = try document.select(CSSText )
            //transform it into a local object (Item)
            var arryText = [String]()
            var arryHtml = [String]()
            for element in elements {
                let text = try element.text()
                let html = try element.outerHtml()
                if html != "" {
                    arryHtml.append(html)
                }
                if text != "" {
                    arryText.append(text)
                }
            }
            txtNewsNumber.text = arryText[0]
            txtTitle.text = arryText[1]
            txtDescription.text = arryText[2]

            
            do{
                 let imageArray =  try? elements.select("meta").array()
                if (imageArray?.count ?? 0) > 0 {
                    let imageUrl = try imageArray?[0].attr("content")
                    print(imageUrl)
                    if imageUrl == nil || imageUrl == "" {
                        webView.loadHTMLString(arryHtml.last! , baseURL: nil)
                    }else{
                        let addHtml = "<div dirction: center class=\"col-xs-12 col-md-5 pull-lef\"> <img width=\"100%\" height=\"500\" src=\"\(imageUrl!)\"  > </div>"
                        webView.loadHTMLString(addHtml + arryHtml.last! , baseURL: nil)
                    }
                }else {
                    webView.loadHTMLString(arryHtml.last! , baseURL: nil)

                }
            }catch{
            }
            
        } catch let error {
            UIAlertController.showAlert("Error: \(error)", self)
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
//                self.imgView.image = UIImage(data: data)
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let css = " body { background-color : #434343 ; color: #ffffff  ; direction: rtl ; display:inline-block ; font-size: 40px ; font-weight: bold; font-family: \"Shabnam-Bold-FD\"}"
        
        let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
        
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
}


extension UIAlertController {
    static public func showAlert(_ message: String, _ controller: UIViewController) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
}
