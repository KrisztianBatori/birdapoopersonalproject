//
//  ReviewService.swift
//  Bird-A-Poo
//
//  Created by Báthory Krisztián on 2019. 08. 14..
//  Copyright © 2019. Golden Games. All rights reserved.
//

import StoreKit.SKStoreReviewController

class ReviewService {
    
    private init() {}
    static let shared = ReviewService()
    
    private let defaults = UserDefaults.standard
    private let app = UIApplication.shared
    
    private var lastRequest: Date? {
        get {
            return defaults.value(forKey: "ReviewService.lastRequest") as? Date
        }
        set {
            defaults.set(newValue, forKey: "ReviewService.lastRequest")
        }
    }
    
    private var twoWeeksAgo: Date {
        return Calendar.current.date(byAdding: .day, value: -14, to: Date())!
    }
    
    private var shouldRequestReview: Bool {
        if lastRequest == nil {
            return true
        }
        else if let lastRequest = self.lastRequest, lastRequest < twoWeeksAgo {
            return true
        }
        return false
    }
    
    func requestReview(isWrittenReview: Bool = false) -> Bool {
        if #available(iOS 10.3, *) {
            if isWrittenReview {
                let appStoreUrl = URL(string: "https://itunes.apple.com/app/idXXXXXXXXXX?action=write-review")!
                app.open(appStoreUrl)
            }
            else {
                guard shouldRequestReview else {return false}
                SKStoreReviewController.requestReview()
                lastRequest = Date()
            }
            return true
        } else {
            return false
        }
    }
}
