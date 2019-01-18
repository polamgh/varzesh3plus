//
//  NewsParse.swift
//  Varzesh3+
//
//  Created by Macintosh on 7/25/1397 AP.
//  Copyright © 1397 ali. All rights reserved.
//

import Foundation
import SwiftSoup

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
//            if arryHtml.count > 1{
            webView.loadHTMLString(arryHtml.last! , baseURL: nil)
//            }else{
//                webView.loadHTMLString(arryHtml[0], baseURL: nil)
//            }
            
            
            do{
                 let imageArray =  try? elements.select("meta").array()
                if (imageArray?.count ?? 0) > 0 {
                    let imageUrl = try imageArray?[0].attr("content")
                    print(imageUrl)
                    if imageUrl == nil || imageUrl == "" {
                        imgView.isHidden = true
                    }else{
                        self.downloadImage(from: URL(string: imageUrl ?? "")!)
                    }
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
                self.imgView.image = UIImage(data: data)
            }
        }
    }
}


extension UIAlertController {
    static public func showAlert(_ message: String, _ controller: UIViewController) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
}
