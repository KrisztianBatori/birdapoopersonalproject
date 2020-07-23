//
//  AlertOption.swift
//  Bird-A-Poo
//
//  Created by Báthory Krisztián on 2019. 09. 18..
//  Copyright © 2019. Golden Games. All rights reserved.
//

import UIKit.UIAlertController

class AlertOption {
    
    init(optionTitle: String, optionStyle: UIAlertAction.Style, optionHandler: (((UIAlertAction) -> Void)?)) {
        title = optionTitle
        style = optionStyle
        handler = optionHandler
    }
    
    let title: String
    let style: UIAlertAction.Style
    let handler: (((UIAlertAction) -> Void)?)
}
