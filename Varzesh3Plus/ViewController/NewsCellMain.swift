//
//  NewsCellMain.swift
//  Varzesh3Plus
//
//  Created by Ali Ghanavati on 10/27/1397 AP.
//  Copyright © 1397 AP Ali Ghanavati. All rights reserved.
//

import UIKit
import WebKit

class NewsCellMain: UITableViewCell {

    @IBOutlet var imageView1: UIImageView!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var txtDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       self.viewBack.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
