//
//  BaseTabBarView.swift
//  Varzesh3Plus
//
//  Created by Macintosh on 11/1/1397 AP.
//  Copyright © 1397 Ali Ghanavati. All rights reserved.
//

import UIKit
var feedURL = URL(string: "https://www.varzesh3.com/rss/all")
var Page_Title = "همه اخبار"
class BaseTabBarView: UITabBarController  , UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    // UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0:
            feedURL = URL(string: "https://www.varzesh3.com/rss/all")
            Page_Title = "همه اخبار"
        case 1:
            feedURL = URL(string: "https://www.varzesh3.com/rss/domesticFootball")
            Page_Title = "فوتبال داخلی"
        case 2:
            feedURL = URL(string: "https://www.varzesh3.com/rss/foreignFootball")
            Page_Title = "فوتبال خارجی"
        default:
            feedURL = URL(string: "https://www.varzesh3.com/rss/all")
        }
        print( item.tag)
    }
    
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        print("Selected view controller")
    }
    

}
