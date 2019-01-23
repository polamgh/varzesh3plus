//
//  VideoViewController.swift
//  Varzesh3Plus
//
//  Created by Macintosh on 11/3/1397 AP.
//  Copyright © 1397 Ali Ghanavati. All rights reserved.
//

import UIKit
import SwiftSoup


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
        
        let story = UIStoryboard.init(name: "ModalView", bundle: nil)
        let modal = story.instantiateViewController(withIdentifier: "ModalView") as! ModalViewController
        ViedeoParser().getDataFromLink(link: link ?? "") { (modelParseCss, error) in
            if error == nil{
                modal.modelParseCss = modelParseCss
                self.parse(CSSText : (modelParseCss?.newsHtml)!)
                do{
                    let doc: Document = try SwiftSoup.parse((modelParseCss?.newsHtml) ?? "")
                    let video: Elements = try doc.select("iframe[src]")
                    var html = try video.outerHtml()
                    modal.modelParseCss?.newsHtml = html
                }catch{
                    
                }
                modal.link = link
                self.show(modal, sender: self)
            }else{
                guard let err = error as? VarzeshError else {
                    return
                }
                UIAlertController.showAlert(err.localizedDescription , self )
            }
        }
        
    }
    
}





extension VideoViewController {
    func parse(CSSText : String)  {
     
       
        do {
            do{
                let doc: Document = try SwiftSoup.parse(CSSText)
                let links: Elements = try doc.select("a[href]") // a with href
                let pngs: Elements = try doc.select("img[src$=.jpg]")
                let video: Elements = try doc.select("iframe[src]")
                
                // img with src ending .png
                let masthead: Element? = try doc.select("div.masthead").first()
                
                // div with class=masthead
                let resultLinks: Elements? = try doc.select("h3.r > a") // direct a after h3
            } catch Exception.Error(let type, let message){
                print(message)
            } catch {
                print("error")
            }
        } catch  {
            print("error")
        }

    }
}
