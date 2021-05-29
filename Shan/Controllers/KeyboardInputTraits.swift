//
//  KeyboardInputTraits.swift
//  Shan
//
//  Created by NorHsangPha BoonHse on 7/5/2564 BE.
//  Modified for return key
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
            let appearanceIsDark = (proxy.keyboardAppearance == UIKeyboardAppearance.dark) || self.traitCollection.userInterfaceStyle == .dark
            if appearanceIsDark != layout.darkMode {
                self.updateAppearances(appearanceIsDark)
            }
        }
        
        
    }
    
    func returnKeyTextAgent() {
        returnKeyTextTimer?.invalidate()
        returnKeyTextTimer = UIScreen.main.displayLink(withTarget: self, selector: #selector(KeyboardViewController.getReturnKeyType))
        returnKeyTextTimer?.add(to: RunLoop.current, forMode: RunLoop.Mode.default)
    }
    
    @objc func getReturnKeyType() {
        
        let returnKeyType = self.textDocumentProxy.returnKeyType
        
        
        if let layout = self.layout {
            if returnKeyType != layout.returnKeyType {
                self.updateReturnKeyText(returnKeyType ?? .default)
            }
        }
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // Trait collection has already changed
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        // Trait collection will change. Use this one so you know what the state is changing to.
    }
}

