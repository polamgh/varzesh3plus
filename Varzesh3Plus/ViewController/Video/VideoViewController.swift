//
//  VideoViewController.swift
//  Varzesh3Plus
//
//  Created by Macintosh on 11/3/1397 AP.
//  Copyright © 1397 Ali Ghanavati. All rights reserved.
//

import UIKit
import SwiftSoup
import AVKit
import SafariServices

class VideoViewController: UIViewController {
    var document: Document = Document.init("")
    typealias Item = (text: String, html: String)
    var items: [Item] = []
    @IBOutlet var tableView: UITableView!
    var feed: RSSFeed?
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let parser = FeedParser(URL: feedURL! )
        tableView.delegate = self
        tableView.dataSource = self
        self.title = Page_Title
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
        
        Loading.start()
        parser.parseAsync { [weak self] (result) in
            self?.feed = result.rssFeed
            DispatchQueue.main.async {
                guard let feeds = self?.feed?.items else{
                    return
                }
                for fee in feeds {
                   fee.data =  self?.getLink(CSSText: fee.description ?? "")
                }
                Loading.stop()
                self?.tableView.reloadData()
            }
        }
    }
    
    
    func getLink(CSSText : String) -> Data? {
        var CSSText2 = ""
        CSSText2 = CSSText.replacingOccurrences(of: "<![CDATA[", with: "")
        CSSText2 = CSSText2.replacingOccurrences(of: "]]>", with: "")
        
        do{
            let doc: Document = try SwiftSoup.parse(CSSText2)
            let pngs: Elements = try doc.select("img[src$=.jpg]")
            var pngString = (pngs.first()?.description) ?? ""
            pngString = pngString.replacingOccurrences(of: "<img src=\"", with: "")
            pngString = pngString.replacingOccurrences(of: "\">", with: "")
            let url = URL(string: pngString)
            guard let urlSafe : URL =  url else {
                return nil
            }
            let data = try? Data(contentsOf: urlSafe)
            guard let dataSafe : Data =  data else {
                return nil
            }
            return dataSafe
//            cell.imageView1.image = UIImage(data: dataSafe)
            
        } catch Exception.Error(let type, let message){
            print(message)
        } catch {
            print("error")
        }
        return nil
    }
    
    
    @objc func refreshHandler() {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
            if #available(iOS 10.0, *) {
                self?.tableView.refreshControl?.endRefreshing()
            }
            self?.tableView.reloadData()
        })
    }
    
    
}


extension VideoViewController : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return self.feed?.items?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsCellMain
        cell.txtTitle.text = self.feed?.items?[indexPath.row].title
//        self.parse(CSSText: (self.feed?.items?[indexPath.row].description)!)
//        var CSSText2 = (self.feed?.items?[indexPath.row].description)!
        guard let safeData : Data = (self.feed?.items?[indexPath.row].data) else{
            return cell
        }
        cell.imageView1.image = UIImage(data: safeData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Loading.start()
        let cell = tableView.cellForRow(at: indexPath) as! NewsCellMain
        print(cell.txtTitle.text ?? "")
        tableView.reloadRows(at: [indexPath], with: .automatic)
        let link = self.feed?.items?[indexPath.row].link ?? ""
        Loading.start()
        ViedeoParser().getDataFromLink(link: link  , cssString: ".tamasha-video-embed-frame") { (modelParseCss, error) in
            if error == nil{
                do{
//                    if modelParseCss?.newsHtml == "" {
                        self.showToSafari(link: link)
                        return
//                    }
                    let doc: Document = try SwiftSoup.parse((modelParseCss?.newsHtml) ?? "")
                    let video: Elements = try doc.select("iframe[src]")
                    let html = try video.outerHtml()
                    let linkVideo = html.replacingOccurrences(of: "<iframe src=\"", with: "")
                    let array = linkVideo.split(separator: "?")
                    let urlFromServer = String((array.first) ?? "" )
                    print(urlFromServer)
                    ViedeoParser().getDataFromLink(link: urlFromServer , cssString: ".mainWrapper") { (modelParseCss, error) in
                        do{
                            let doc: Document = try SwiftSoup.parse((modelParseCss?.newsHtml) ?? "")
                            let video: Elements = try doc.select("source[src$=.mp4]")
                            let str : String = video.array().first?.description ?? ""
                            let urlTemp = str.replacingOccurrences(of: "<source src=\"", with: "")
                            let urlTemp2 = urlTemp.split(separator: "\"")
                            let finalUrlStr : String = String(urlTemp2.first ?? "")
                            let videoURL = URL(string: finalUrlStr)
                            guard let url = videoURL else {
                                Loading.stop()
                                 UIAlertController.showAlert("خطایی رخ داده" , self )
                                return
                            }
                            let player = AVPlayer(url: url)
                            let playerViewController = AVPlayerViewController()
                            playerViewController.player = player
                            
                            self.present(playerViewController, animated: true) {
                                Loading.stop()
                                player.play()
                            }
                        }catch{
                            
                        }
                    }
                }catch{
                    
                }
            }else{
                guard let err = error as? VarzeshError else {
                    return
                }
                UIAlertController.showAlert(err.localizedDescription , self )
            }
        }
        
    }
    
    
    func showToSafari(link : String)  {
        Loading.stop()
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
        guard let url = URL(string: linkForShow) else {
            UIAlertController.showAlert("error : \(link)", self)
            return
        }
        let svc = SFSafariViewController(url: url  )
        self.present(svc, animated: true, completion: nil)
    }
    
}
