//
//  ModalViewController.swift
//  Varzesh3Plus
//
//  Created by Ali Ghanavati on 10/27/1397 AP.
//  Copyright © 1397 AP Ali Ghanavati. All rights reserved.
//

import UIKit
import SwiftSoup

class ModalViewController: UIViewController {
    var document: Document = Document.init("")
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var txtDescription: UITextView!
    var strDescription : String?
    var link : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFromLink(link: link ?? "")
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
            self.downloadHTML(urlString: linkForShow, cssString: ".news-page--news-text,[property=og:image]")
                //                    [property=og:image]
                //                    .news-page--news-text,
               
        }
        
    }

}
