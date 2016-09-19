//
//  WassupMessage.swift
//  wassup
//
//  Created by MAC on 9/19/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

public protocol WassupMessageDelegate {
    func didTapMessage()
}

class WassupMessage: GSMessage {

    
    class func showMessage(view: UIView, text: String, type: GSMessageType, options: [GSMessageOption]?) {
        GSMessage.showMessageAddedTo(text, type: type, options: options, inView: view, inViewController: nil)
    }
}