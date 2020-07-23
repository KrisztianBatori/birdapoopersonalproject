//
//  GameViewController.swift
//  Bird-A-Poo
//
//  Created by Báthory Krisztián on 2019. 02. 03..
//  Copyright © 2019. Golden Games. All rights reserved.
//

import SpriteKit
import GoogleMobileAds
import PersonalizedAdConsent
import Firebase
import CoreLocation

class GameViewController: UIViewController, GADBannerViewDelegate, CLLocationManagerDelegate {
    
    static var isAdmobLoaded = false
    var consentCollected: Bool = false
    var locationManager: CLLocationManager?
    static var isPersonalizedAdsAllowed = false
    
    var loadingTimer: Timer!
    var imageView: UIImageView = UIImageView()
    
    static let userDataFromCloud = CloudManager.loadFromCloud()
    static var fullVersionEnabled = false
    
    static var bannerView: GADBannerView!
    static let bannerRequest = GADRequest()
    static var requestReviewCounter = 0
    
    @IBOutlet weak var birdImage: UIImageView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        
        imageView = UIImageView(frame: self.view.bounds)
        imageView.image = UIImage(named: "GVCBackgroundColor.png")
        self.view.addSubview(imageView)
        self.view.addSubview(birdImage)
        self.view.addSubview(loadingLabel)
        
        loadingTimer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(self.loadMainMenu), userInfo: nil, repeats: true)
        
        SongManager.shared.setup()
        SceneTransitionSongManager.shared.setup()
        
        if let _ = CloudManager.attemptToRetrieveData(for: "UserTransaction") {
            GameViewController.fullVersionEnabled = true
        }
        else if let _ = UserDefaults.standard.value(forKey: "UserTransaction") {
            GameViewController.fullVersionEnabled = true
            CloudManager.saveToCloud(data: "1", dataKey: "UserTransaction")
        }
        else {
            GameViewController.bannerView = GADBannerView(adSize: kGADAdSizeBanner)
            GameViewController.bannerView.isAutoloadEnabled = false
            addBannerViewToView(GameViewController.bannerView)
            GameViewController.bannerView.adUnitID = "ca-app-pub-XXX"
            GameViewController.bannerView.rootViewController = self
            GameViewController.bannerView.delegate = self
            GameViewController.bannerView.isHidden = true
            
            GameViewController.bannerRequest.testDevices = ["XXX", "XXX"]
        }
        
        if let userCloudScore = CloudManager.attemptToRetrieveData(for: "Highscore") {
            let userHighScore = UserDefaults.standard
            userHighScore.set(userCloudScore, forKey: "Highscore")
            userHighScore.synchronize()
        }
        else if let userLocalScore = UserDefaults.standard.value(forKey: "Highscore") {
            CloudManager.saveToCloud(data: userLocalScore as! String, dataKey: "Highscore")
        }
        
        loadMainMenu()

    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            PACConsentInformation.sharedInstance.requestConsentInfoUpdate(forPublisherIdentifiers: ["pub-XXX"])
            {(_ error: Error?) -> Void in
                if let error = error {
                    print(error)
                } else {
                    if !PACConsentInformation.sharedInstance.isRequestLocationInEEAOrUnknown {
                        print("USER CONSENT IS NOT REQUIRED, PERSONALIZED ADS ARE ALLOWED")
                        Analytics.setAnalyticsCollectionEnabled(true)
                        GameViewController.isPersonalizedAdsAllowed = true
                    }
                    else {
                        GADMobileAds.sharedInstance().requestConfiguration.tagForUnderAge(ofConsent: true)
                        PACConsentInformation.sharedInstance.isTaggedForUnderAgeOfConsent = true
                        PACConsentInformation.sharedInstance.consentStatus = .nonPersonalized
                    }
                    PACConsentInformation.sharedInstance.isTaggedForUnderAgeOfConsent ? print("TAGGED FOR UNDERAGE CONSENT") : print("***NOT*** TAGGED FOR UNDERAGE CONSENT")
                    PACConsentInformation.sharedInstance.isRequestLocationInEEAOrUnknown ? print("USER IS LOCATED IN THE EUROPEAN ECONOMIC AREA") : print("USER IS ***NOT*** LOCATED IN THE EUROPEAN ECONOMIC AREA")
                    print("PERSONALIZED ADS ARE ***NOT*** ALLOWED")
                }
            }
            self.consentCollected = true
        }
        else if status == .notDetermined {
            print("WAITING FOR USER PERMISSION")
        }
        else {
            print("USER DID NOT GIVE PERMISSION TO ACCESS LOCATION DATA")
            print("PERSONALIZED ADS ARE ***NOT*** ALLOWED")
            self.consentCollected = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc
    func loadMainMenu() {
        if GameViewController.isAdmobLoaded && (self.consentCollected || GameViewController.fullVersionEnabled) {
            loadingTimer.invalidate()
            self.imageView.removeFromSuperview()
            self.birdImage.removeFromSuperview()
            self.loadingLabel.removeFromSuperview()
            if let view = self.view as! SKView? {
                
                if let scene = MainMenu(fileNamed: "MainMenu") {
                    scene.scaleMode = .fill
                    view.presentScene(scene)
                }
                
                view.ignoresSiblingOrder = true
            }
        }
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("received ad")
    }
}
