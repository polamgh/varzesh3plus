//
//  ViedeoParser.swift
//  Varzesh3Plus
//
//  Created by Macintosh on 11/3/1397 AP.
//  Copyright © 1397 Ali Ghanavati. All rights reserved.
//
import Foundation
import SwiftSoup
import UIKit
import WebKit

class ViedeoParser {
    var document: Document = Document.init("")
    func getDataFromLink(link : String  , cssString : String, completion : @escaping ((modelParseCss : ModelParseCss? ,error: Error?)) -> ())  {
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
            self.downloadHTML(urlString: linkForShow, cssString: cssString){ (modelParseCss, error) in
                completion(( modelParseCss , error ))
            }
            
        }
        
    }
    fileprivate func downloadHTML(urlString : String , cssString : String  , completion : @escaping ((modelParseCss : ModelParseCss? , error : Error?)) -> ()) {
        guard let url = URL(string: urlString) else {
            // an error occurred
            completion((nil , VarzeshError.runtimeError("Error: \(urlString) doesn't seem to be a valid URL") ))
            return
        }
        
        do {
            // content of url
            let html = try String.init(contentsOf: url)
            // parse it into a Document
            document = try SwiftSoup.parse(html)
            // parse css query
            parse(CSSText: cssString){ (modelParseCss , error) in
                completion(( modelParseCss , error ))
                return
            }
            
        } catch let error {
            // an error occurred
            completion((nil , VarzeshError.runtimeError("Error: \(error.localizedDescription)") ))
            return
        }
        
    }
    
    fileprivate func parse(CSSText : String , completion : @escaping (( modelParseCss : ModelParseCss? , error: Error?)) -> ())  {
        var modelParseNews = ModelParseCss()
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
//            modelParseNews.newsNumber = arryText[0]
//            modelParseNews.title = arryText[1]
//            modelParseNews.description = arryText[2]
            
            do{
                let imageArray =  try? elements.select("meta").array()
                if (imageArray?.count ?? 0) > 0 {
                    let imageUrl = try imageArray?[0].attr("content")
                    print(imageUrl ?? "")
                    if imageUrl == nil || imageUrl == "" {
                        modelParseNews.newsHtml = arryHtml.last ?? ""
                        completion((modelParseNews , nil))
                        return
                    }else{
                        let addHtml = "<div dirction: center class=\"col-xs-12 col-md-5 pull-lef\"> <img width=\"100%\" height=\"500\" src=\"\(imageUrl!)\"  > </div>"
                        modelParseNews.newsHtml = addHtml + (arryHtml.last ?? "")
                        completion((modelParseNews , nil))
                        return
                    }
                }else {
                    modelParseNews.newsHtml = arryHtml.last ?? ""
                    completion((modelParseNews , nil))
                    return
                }
            }catch{
                completion((nil , VarzeshError.unknowException))
            }
            
        } catch let error {
            completion((nil , VarzeshError.runtimeError(error.localizedDescription)))
        }
    }
    
    
    
}

