//
//  Loading.swift
//  Varzesh3Plus
//
//  Created by Ali Ghanavati on 10/30/1397 AP.
//  Copyright © 1397 AP Ali Ghanavati. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

class Loading   {
    
    static func start() {
        let activityData = ActivityData(size: CGSize(width: 50, height: 50), message: "لطفا صبر کنید...", messageFont: nil, messageSpacing: nil, type: NVActivityIndicatorType.ballPulseRise, color: nil, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: UIColor.black.withAlphaComponent(0.8), textColor: UIColor.white)
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
    }
    
    static func stop() {
        
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
}
