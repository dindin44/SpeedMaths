//
//  TypingWindow.swift
//  SpeedMath
//
//  Created by Dinesh Vijaykumar on 13/05/2020.
//  Copyright © 2020 Dinesh Vijaykumar. All rights reserved.
//

import Cocoa

extension Notification.Name {
    static let enterNumber = Notification.Name("enterNumber")
    static let removeNumber = Notification.Name("removeNumber")
    static let submitNumber = Notification.Name("submitNumber")
}

class TypingWindow: NSWindow {
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 51 {
            NotificationCenter.default.post(name: .removeNumber, object: nil)
        } else if event.keyCode == 36 {
            NotificationCenter.default.post(name: .submitNumber, object: nil)
        } else {
            guard let characters = event.characters else { return }
            
            if let number = Int(characters) {
                NotificationCenter.default.post(name: .enterNumber, object: number)
            }
        }
    }
}
