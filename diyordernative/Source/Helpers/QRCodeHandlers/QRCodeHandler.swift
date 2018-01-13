//
//  QRCodeHandler.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-12.
//  Copyright © 2018 goopter. All rights reserved.
//

import Foundation
import UIKit

class QRCodeHandler {
    
    static let waitlistRegex = "{[1]}{([A-Za-z0-9\\-]+)}"
    
    static let tableRegex = "{[2]}{([A-Za-z0-9\\-]+)}{([A-Za-z0-9\\-]+)}"
    
    static let menuRegex = "{[3]}{([A-Za-z0-9\\-]+)}{([A-Za-z0-9\\-]+)}"
    
    static let storeRegex = ".*\\/store\\/([\\w-]+)$"
    
    static let productRegex = ".*\\/store\\/product\\/([\\w-]+)\\/([\\w-]+)$"
    
    static let validURLRegex = "/((([A-Za-z]{3,9}:(?:\\/\\/)?)(?:[-;:&=\\+\\$,\\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=\\+\\$,\\w]+@)[A-Za-z0-9.-]+)((?:\\/[\\+~%\\/.\\w-_]*)?\\??(?:[-\\+=&;%@.\\w_]*)#?(?:[\\w]*))?)/"
    
    static func create (result: String?) -> QRCodeHandler {
        
        var handler: QRCodeHandler!
        
        guard let result = result else {
            handler = QRCodeHandler(result: nil)
            return handler
        }
        
        if Utils.isMatch(regex: waitlistRegex, text: result) {
            handler = WaitlistQRCodeHandler (result: result)
        } else if Utils.isMatch(regex: tableRegex, text: result) {
            handler = TableQRCodeHandler (result: result)
        } else if Utils.isMatch(regex: menuRegex, text: result) {
            handler = MenuQRCodeHandler (result: result)
        } else if Utils.isMatch(regex: storeRegex, text: result) {
            handler = StoreQRCodeHandler (result: result)
        } else if Utils.isMatch(regex: productRegex, text: result) {
            handler = ProductQRCodeHandler (result: result)
        } else {
            handler = QRCodeHandler(result: result)
        }
        
        return handler
    }
    
    var result: String? = nil
    
    init(result: String?) {
        self.result = result
    }
    
    func execute (completion: @escaping () -> Void) {
        guard let result = result else {
            completion()
            return
        }
        
        StoreDataLoader.startRequestStore(by: result, completion: {
            status, store in
            
            if status == .success || store != nil {
                completion()
                
                // push to store
            } else if status == .sourceNotFound, let url = URL (string: result) {
                DispatchQueue.main.async {
                    let message = String.init(format: LanguageControl.shared.getLocalizeString(by: "do you want to open url in browser"), result)
                    let alert = UIAlertController(title: LanguageControl.shared.getLocalizeString(by: "external url detected"), message: message, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: LanguageControl.shared.getLocalizeString(by: "cancel"), style: .destructive, handler: {
                        action in
                        completion()
                    }))
                    alert.addAction(UIAlertAction(title: LanguageControl.shared.getLocalizeString(by: "go"), style: .default, handler: {
                        action in
                        completion()
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }))
                    
                    let rootViewController = UIApplication.shared.keyWindow!.rootViewController! as! UINavigationController
                    rootViewController.present(alert, animated: true, completion: nil)
                }
            } else {
                // invalid qr code
            }
        })
    }
}
