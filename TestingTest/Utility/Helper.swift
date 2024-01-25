//
//  Helper.swift
//  TestingTest
//
//  Created by Aditya on 24/01/24.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

private var activityIndicator: NVActivityIndicatorView!
private var containerIndicator: UIView!

public class Helper {
    
    //MARK: - CHECKING IS CONNECTING TO NETWORK
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    //MARK: - For Loading
    class func defaultBlockLoading(_ withMessage: String = "") {
        let activityData = ActivityData(size: CGSize(width: 30, height: 30),
                                        message: withMessage,
                                        messageFont: nil,
                                        type: .ballClipRotate,
                                        color: nil,
                                        padding: nil,
                                        displayTimeThreshold: 2,
                                        minimumDisplayTime: 2,
                                        backgroundColor: nil,
                                        textColor: nil)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    
    class func stopLoading() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        if containerIndicator != nil {
            containerIndicator.removeFromSuperview()
        }
    }
}
