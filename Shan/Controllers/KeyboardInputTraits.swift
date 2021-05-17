//
//  KeyboardInputTraits.swift
//  Shan
//
//  Created by NorHsangPha BoonHse on 7/5/2564 BE.
//
//  Original by Alexei Baboulevitch TransliteratingKeyboard ForwardingView.swift
//  Copyright (c) 2014 Alexei Baboulevitch ("Archagon"). All rights reserved.
//  https://github.com/archagon/tasty-imitation-keyboard.git

import Foundation
import QuartzCore
import UIKit


var traitPollingTimer: CADisplayLink?
var returnKeyTextTimer: CADisplayLink?

extension KeyboardViewController {
    
    func addInputTraitsObservers() {
        // note that KVO doesn't work on textDocumentProxy, so we have to poll
        traitPollingTimer?.invalidate()
        traitPollingTimer = UIScreen.main.displayLink(withTarget: self, selector: #selector(KeyboardViewController.pollTraits))
        traitPollingTimer?.add(to: RunLoop.current, forMode: RunLoop.Mode.default)
    }
    
    @objc func pollTraits() {
        let proxy = self.textDocumentProxy
        
        if let layout = self.layout {
            let appearanceIsDark = (proxy.keyboardAppearance == UIKeyboardAppearance.dark)
            if appearanceIsDark != layout.darkMode {
                self.updateAppearances(appearanceIsDark)
            }
        }
    }
    
    func returnKeyTextAgent() {
        returnKeyTextTimer?.invalidate()
        returnKeyTextTimer = UIScreen.main.displayLink(withTarget: self, selector: #selector(KeyboardViewController.returnKeyText))
        returnKeyTextTimer?.add(to: RunLoop.current, forMode: RunLoop.Mode.default)
    }
    
    @objc func returnKeyText() {

        let returnKeyType = self.textDocumentProxy.returnKeyType

        var text: String

        switch returnKeyType ?? .default {
        case .go, .next, .continue:
            text = "သိုပ်ႇၵႂႃႇ"
        case .google, .search, .route, .yahoo:
            text = "သွၵ်ႈႁႃ"
        case .join:
            text = "ၶဝ်ႈႁူမ်ႈ"
        case .send:
            text = "သူင်ႇ"
        case .done:
            text = "ယဝ်ႉတူဝ်ႈ"
        default:
            text = "return"
        }
        
        if let layout = self.layout {
            if text != layout.returnKeyType {
                self.updateReturnKeyText(text)
            }
        }

    }
}

