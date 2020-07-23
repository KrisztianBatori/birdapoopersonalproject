//
//  InfoMenu.swift
//  Bird-A-Poo
//
//  Created by Báthory Krisztián on 2019. 08. 05..
//  Copyright © 2019. Golden Games. All rights reserved.
//

import SpriteKit.SKSpriteNode
import MessageUI

class InfoMenu: SKScene, MFMailComposeViewControllerDelegate {
    
    var returnButton = SKSpriteNode()
    var returnButtonPosX: CGFloat?
    var returnButtonPosy: CGFloat?
    
    var rateButton = SKSpriteNode()
    var reportButton = SKSpriteNode()
    
    var buttonClickAudio = SKAudioNode(fileNamed: "ButtonClick.wav")
    
    let reviewService = ReviewService.shared
    
    override func didMove(to view: SKView) {
        
        Background.createBackGround(BackgroundImage: "InfoBackground", forScene: self)
        
        returnButton = ButtonGenerator.generateButton(imageName: "ReturnButton", scale: 0.1, position: CGPoint(x: returnButtonPosX!, y: returnButtonPosy!))
        
        rateButton = ButtonGenerator.generateButton(imageName: "RateButton", scale: 1, position: CGPoint(x: -(self.frame.size.width * 0.355), y: -(self.frame.size.height / 8)))
        reportButton = ButtonGenerator.generateButton(imageName: "ReportButton", scale: 1, position: CGPoint(x: -(self.frame.size.width * 0.13), y: -(self.frame.size.height / 8)))
        
        self.addChild(returnButton)
        self.addChild(rateButton)
        self.addChild(reportButton)
        
        buttonClickAudio.autoplayLooped = false
        buttonClickAudio.name = "button"
        self.addChild(buttonClickAudio)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let pointOfTouch = touch.previousLocation(in: self)
            
            if returnButton.contains(pointOfTouch) {
                
                SoundManager.playSound(sound: buttonClickAudio)
                returnButton.run(SKAction.fadeAlpha(to: 0.3, duration: 0.1), completion: {
                    
                    if let scene = MainMenu(fileNamed: "MainMenu") {
                        
                        scene.scaleMode = .fill
                        
                        self.view?.presentScene(scene, transition: SKTransition.flipVertical(withDuration: 0.7))
                    }
                })
            }
            
            else if reportButton.contains(pointOfTouch) {
                
                SoundManager.playSound(sound: buttonClickAudio)
                reportButton.run(SKAction.fadeAlpha(to: 0.3, duration: 0.1), completion: {
                    
                    self.showMailComposer()
                    
                })
            }
            
            else if rateButton.contains(pointOfTouch) {
                
                SoundManager.playSound(sound: buttonClickAudio)
                
                rateButton.run(SKAction.fadeAlpha(to: 0.3, duration: 0.1), completion: {
                    let deadline = DispatchTime.now() + .milliseconds(100)
                    DispatchQueue.main.asyncAfter(deadline: deadline, execute: {[weak self] in
                        self?.reviewService.requestReview(isWrittenReview: true)
                    })
                })
                
                rateButton.run(SKAction.sequence([
                    SKAction.wait(forDuration: 0.25),
                    SKAction.fadeAlpha(to: 1.0, duration: 0.1)
                    ]))
            }
            
        }
    }
    
    func showMailComposer() {
        guard MFMailComposeViewController.canSendMail() else {
            AlertHandler.showAlert(on: self, title: "Please set up a Mail account to use this service", message: String(), preferredStyle: UIAlertController.Style.alert, animated: true, delay: 0.1, options:
                AlertOption.init(optionTitle: "Open Mail", optionStyle: UIAlertAction.Style.cancel, optionHandler: {
                    (action) in
                    let appStoreUrl = URL(string: "https://itunes.apple.com/app/id1108187098")!
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(appStoreUrl)
                    } else {
                        UIApplication.shared.openURL(appStoreUrl)
                    }
                    self.reportButton.run(SKAction.fadeAlpha(to: 1.0, duration: 0.1))
                }),
                AlertOption.init(optionTitle: "Cancel", optionStyle: UIAlertAction.Style.default, optionHandler: {
                    (action) in self.reportButton.run(SKAction.fadeAlpha(to: 1.0, duration: 0.1))
                })
            )
            return
        }
        print("everything ok")
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["birdapoo2019@gmail.com"])
        composer.setSubject("Bird-A-Poo Bug - \(DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .medium, timeStyle: .short))")
        
        let dictionaryForAppVersion = Bundle.main.infoDictionary!
        composer.setMessageBody(
            """
            <br>
            <font size = "5"><b>SYSTEM INFORMATION:</b></font>
            <br>
            <br>
            Device model: \(UIDevice.current.modelName)<br>
            iOS version: \(ProcessInfo().operatingSystemVersionString)<br>
            App version: \(dictionaryForAppVersion["CFBundleShortVersionString"] as! String)(\(dictionaryForAppVersion["CFBundleVersion"] as! String)) - \(GameViewController.fullVersionEnabled ? "Full" : "Free") version<br>
            <br>
            <br>
            <br>
            <font size = "5"><b>OVERVIEW:</b></font>
            <br>
            <b>[Please try to answer the questions]</b>
            <br>
            <br>
            Number of bugs raising on this report:<b></b>
            <br>
            The app crashed when the bug was encountered (y/n):
            <br>
            iCloud was enabled when the bug was encountered (y/n):
            <br>
            It was not possible to leave the current menu/scene after the bug was encountered (y/n):
            <br>
            The bug has been present at multiple devices/os systems (y/n):
            <br>
            <br>
            <br>
            <br>
            <font size = "5"><b>DESCRIPTION OF THE BUG(S):</b></font>
            <br><br>
            <font size="4" color="red">
                <strong>Please try to include attachments (screenshots or recordings) in the report, especially if you are able to recreate the bug.
                </strong>
            </font>
            <br><br><br><br>
            [Start of description. Remove this line if necessary.]
            <br><br><br><br>
            """, isHTML: true)
        
        self.view?.window?.rootViewController?.present(composer, animated: true)
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            controller.dismiss(animated: true)
        }
        reportButton.run(SKAction.fadeAlpha(to: 1.0, duration: 0.1))
        switch result {
            case.cancelled:
                print("Cancelled")
            case.failed:
                print("Failed to send")
            case .saved:
                print("Saved")
            case.sent:
                print("Email Sent")
        }
        
        controller.dismiss(animated: true)
    }
}

extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
