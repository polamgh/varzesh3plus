//
//  ViewController.swift
//  Varzesh3Plus
//
//  Created by Ali Ghanavati on 10/26/1397 AP.
//  Copyright © 1397 AP Ali Ghanavati. All rights reserved.
//

import UIKit
import SwiftSoup
import DeckTransition

let feedURL = URL(string: "https://www.varzesh3.com/rss/all")!
class ViewController: UIViewController {
    var document: Document = Document.init("")
    typealias Item = (text: String, html: String)
    var items: [Item] = []
    @IBOutlet var tableView: UITableView!
    var feed: RSSFeed?
    let parser = FeedParser(URL: feedURL)
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "همه اخبار"
        UINavigationBar.appearance().backgroundColor = UIColor.black
        UIBarButtonItem.appearance().tintColor = UIColor.white
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
        
        parser.parseAsync { [weak self] (result) in
            self?.feed = result.rssFeed
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
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


extension ViewController : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return self.feed?.items?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsCellMain
        cell.txtTitle.text = self.feed?.items?[indexPath.row].title
        cell.txtDescription.text = self.feed?.items?[indexPath.row].description
//        cell2.txtBody.text =  self.feed?.items?[indexPath.row].link
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! NewsCellMain
        print(cell.txtTitle.text ?? "")
        tableView.reloadRows(at: [indexPath], with: .automatic)
        let story = UIStoryboard.init(name: "ModalView", bundle: nil)
        let modal = story.instantiateViewController(withIdentifier: "ModalView") as! ModalViewController
        let transitionDelegate = DeckTransitioningDelegate()
        modal.link = self.feed?.items?[indexPath.row].link ?? ""
        modal.transitioningDelegate = transitionDelegate
        modal.modalPresentationStyle = .custom
        self.present(modal, animated: true, completion: nil)
        
        
        
    }
}

