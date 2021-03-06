//
//  KeyboardViewController.swift
//  Shan
//
//  Created by NorHsangPha BoonHse on 1/5/2564 BE.
//  Modified for return, backspace, shift and darkmode
//
//  Original by Alexei Baboulevitch TransliteratingKeyboard ForwardingView.swift
//  Copyright (c) 2014 Alexei Baboulevitch ("Archagon"). All rights reserved.
//  https://github.com/archagon/tasty-imitation-keyboard.git

import UIKit
import AudioToolbox

let metrics: [String:Double] = [
    "topBanner": 30
]
func metric(_ name: String) -> CGFloat { return CGFloat(metrics[name]!) }

// TODO: move this somewhere else and localize
let kAutoCapitalization = "kAutoCapitalization"
let kPeriodShortcut = "kPeriodShortcut"
let kKeyboardClicks = "kKeyboardClicks"
let kSmallLowercase = "kSmallLowercase"

class KeyboardViewController: UIInputViewController {
    
    let backspaceDelay: TimeInterval = 0.5
    let backspaceRepeat: TimeInterval = 0.1
    let backspaceLongG: TimeInterval = 0.3
    
    var keyboard: Keyboard!
    var forwardingView: ForwardingView!
    var layout: KeyboardLayout?
    var heightConstraint: NSLayoutConstraint?
    
    var currentMode: Int {
        didSet {
            if oldValue != currentMode {
                setMode(currentMode)
            }
        }
    }
    
    var backspaceActive: Bool {
        get {
            return (backspaceDelayTimer != nil) || (backspaceRepeatTimer != nil) || (backspaceLongGTimer != nil)
        }
    }
    var backspaceDelayTimer: Timer?
    var backspaceRepeatTimer: Timer?
    var backspaceLongGTimer: Timer?
    
    enum AutoPeriodState {
        case noSpace
        case firstSpace
    }
    
    var autoPeriodState: AutoPeriodState = .noSpace
    var lastCharCountInBeforeContext: Int = 0
    
    var shiftState: ShiftState {
        didSet {
            switch shiftState {
            case .disabled:
                self.updateKeyCaps(false)
            case .enabled:
                self.updateKeyCaps(true)
            case .locked:
                self.updateKeyCaps(true)
            }
        }
    }
    
    // state tracking during shift tap
    var shiftWasMultitapped: Bool = false
    var shiftStartingState: ShiftState?
    
    var keyboardHeight: CGFloat {
        get {
            if let constraint = self.heightConstraint {
                return constraint.constant
            }
            else {
                return 0
            }
        }
        set {
            self.setHeight(newValue)
        }
    }
    
    // TODO: why does the app crash if this isn't here?
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        UserDefaults.standard.register(defaults: [
            kAutoCapitalization: true,
            kPeriodShortcut: true,
            kKeyboardClicks: false,
            kSmallLowercase: false
        ])
        
        self.shiftState = .disabled
        self.currentMode = 0
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.keyboard = defaultKeyboard(needsInputModeSwitchKey)
        
        self.forwardingView = ForwardingView(frame: CGRect.zero)
        self.view.addSubview(self.forwardingView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardViewController.defaultsChanged(_:)), name: UserDefaults.didChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    deinit {
        backspaceDelayTimer?.invalidate()
        backspaceRepeatTimer?.invalidate()
        backspaceLongGTimer?.invalidate()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func defaultsChanged(_ notification: Notification) {
        //let defaults = notification.object as? NSUserDefaults
        self.updateKeyCaps(self.shiftState.uppercase())
    }
    
    // without this here kludge, the height constraint for the keyboard does not work for some reason
    var kludge: UIView?
    func setupKludge() {
        if self.kludge == nil {
            let kludge = UIView()
            self.view.addSubview(kludge)
            kludge.translatesAutoresizingMaskIntoConstraints = false
            kludge.isHidden = true
            
            let a = NSLayoutConstraint(item: kludge, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0)
            let b = NSLayoutConstraint(item: kludge, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0)
            let c = NSLayoutConstraint(item: kludge, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
            let d = NSLayoutConstraint(item: kludge, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
            self.view.addConstraints([a, b, c, d])
            
            self.kludge = kludge
        }
    }
    
    var constraintsAdded: Bool = false
    func setupLayout() {
        if !constraintsAdded {
            self.layout = type(of: self).layoutClass.init(model: self.keyboard, superview: self.forwardingView, layoutConstants: type(of: self).layoutConstants, globalColors: type(of: self).globalColors, darkMode: self.darkMode(), solidColorMode: self.solidColorMode(), returnKeyType: self.returnKeyTextType())
            
            self.layout?.initialize()
            self.setMode(0)
            
            self.setupKludge()
            
            self.updateKeyCaps(self.shiftState.uppercase())
            self.updateCapsIfNeeded()
            
            self.updateAppearances(self.darkMode())
            self.addInputTraitsObservers()
            
            self.updateReturnKeyText(self.returnKeyTextType())
            self.returnKeyTextAgent()
            
            self.constraintsAdded = true
        }
    }
    
    // only available after frame becomes non-zero
    func darkMode() -> Bool {
        let darkMode = { () -> Bool in
            let proxy = self.textDocumentProxy
            return proxy.keyboardAppearance == UIKeyboardAppearance.dark
        }()
        
        return darkMode
    }
    
    func returnKeyTextType() -> UIReturnKeyType {
        
        let returnKeyType = self.textDocumentProxy.returnKeyType
            
        return returnKeyType ?? .default

    }
    
    func solidColorMode() -> Bool {
        return UIAccessibility.isReduceTransparencyEnabled
    }
    
    var lastLayoutBounds: CGRect?
    override func viewDidLayoutSubviews() {
        if view.bounds == CGRect.zero {
            return
        }
        
        self.setupLayout()
        
        // NOTE: self.interfaceOrientation
        let orientationSavvyBounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.height(forOrientation: self.preferredInterfaceOrientationForPresentation, withTopBanner: false))
        
        if (lastLayoutBounds != nil && lastLayoutBounds == orientationSavvyBounds) {
            // do nothing
        }
        else {
            let uppercase = self.shiftState.uppercase()
            let characterUppercase = (UserDefaults.standard.bool(forKey: kSmallLowercase) ? uppercase : true)

            self.forwardingView.frame = orientationSavvyBounds
            self.layout?.layoutKeys(self.currentMode, uppercase: uppercase, characterUppercase: characterUppercase, shiftState: self.shiftState, needsInputModeSwitchKey: self.needsInputModeSwitchKey)
            self.lastLayoutBounds = orientationSavvyBounds
            self.setupKeys()
        }
        
        // MARK:- for bannerView
        
        let newOrigin = CGPoint(x: 0, y: self.view.bounds.height - self.forwardingView.bounds.height)
        self.forwardingView.frame.origin = newOrigin
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillLayoutSubviews() {
     
        super.viewWillLayoutSubviews()
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    // TODO: this is currently not working as intended; only called when selection changed -- iOS bug
    override func textDidChange(_ textInput: UITextInput?) {
        self.contextChanged()
    }

    override func viewWillAppear(_ animated: Bool) {
        // NOTE: self.interfaceOrientation
        self.keyboardHeight = self.height(forOrientation: self.preferredInterfaceOrientationForPresentation, withTopBanner: true)
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        self.forwardingView.resetTrackedViews()
        self.shiftStartingState = nil
        self.shiftWasMultitapped = false
        
        // optimization: ensures smooth animation
        if let keyPool = self.layout?.keyPool {
            for view in keyPool {
                view.shouldRasterize = true
            }
        }
        
        self.keyboardHeight = self.height(forOrientation: toInterfaceOrientation, withTopBanner: true)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        // optimization: ensures quick mode and shift transitions
        if let keyPool = self.layout?.keyPool {
            for view in keyPool {
                view.shouldRasterize = false
            }
        }
    }
    
    func height(forOrientation orientation: UIInterfaceOrientation, withTopBanner: Bool) -> CGFloat {
        let isPad = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
        
        //TODO: hardcoded stuff
        let actualScreenWidth = (UIScreen.main.nativeBounds.size.width / UIScreen.main.nativeScale)
        let canonicalPortraitHeight: CGFloat
        let canonicalLandscapeHeight: CGFloat
        if isPad {
            canonicalPortraitHeight = 264
            canonicalLandscapeHeight = 352
        }
        else {
            canonicalPortraitHeight = orientation.isPortrait && actualScreenWidth >= 400 ? 226 : 216
            canonicalLandscapeHeight = 162
        }
        
        let topBannerHeight = (withTopBanner ? metric("topBanner") : 0)
        
        return CGFloat(orientation.isPortrait ? canonicalPortraitHeight + topBannerHeight : canonicalLandscapeHeight + topBannerHeight)
    }
    
    func setupKeys() {
        if self.layout == nil {
            return
        }
        
        for page in keyboard.pages {
            for rowKeys in page.rows { // TODO: quick hack
                for key in rowKeys {
                    if let keyView = self.layout?.viewForKey(key) {
                        keyView.removeTarget(nil, action: nil, for: UIControl.Event.allEvents)
                        
                        switch key.type {
                        case Key.KeyType.keyboardChange:
                            keyView.addTarget(self,
                                                  action: #selector(handleInputModeList(from:with:)),
                                                  for: .allTouchEvents)
                            keyView.originalViewTouch = true
                            keyView.addTarget(self,
                                              action: #selector(KeyboardViewController.playOtherKeySound),
                                              for: .touchDown)
                        case Key.KeyType.backspace:
                            let cancelEvents: UIControl.Event = [UIControl.Event.touchDragOutside, UIControl.Event.touchDragExit, UIControl.Event.touchUpInside, UIControl.Event.touchUpOutside, UIControl.Event.touchCancel]
                            
                            keyView.addTarget(self,
                                              action: #selector(KeyboardViewController.backspaceDown(_:)),
                                              for: .touchUpInside)
                            keyView.addTarget(self,
                                              action: #selector(KeyboardViewController.backspaceUp(_:)),
                                              for: cancelEvents)
                            keyView.addTarget(self, action: #selector(KeyboardViewController.handleBackspaceLongPress(_:)), for: .touchDown)
                            keyView.addTarget(self,
                                              action: #selector(KeyboardViewController.keyPressedHelper(_:)),
                                              for: .touchUpInside)
                        case Key.KeyType.shift:
                            keyView.addTarget(self,
                                              action: #selector(KeyboardViewController.shiftDown(_:)),
                                              for: .touchDown)
                            keyView.addTarget(self,
                                              action: #selector(KeyboardViewController.shiftUp(_:)),
                                              for: .touchUpInside)
                            keyView.addTarget(self,
                                              action: #selector(KeyboardViewController.shiftDoubleTapped(_:)),
                                              for: .touchDownRepeat)
                            keyView.addTarget(self,
                                              action: #selector(KeyboardViewController.playOtherKeySound),
                                              for: .touchDown)
                        case Key.KeyType.modeChange:
                            keyView.addTarget(self,
                                              action: #selector(KeyboardViewController.modeChangeTapped(_:)),
                                              for: .touchDown)
                            keyView.addTarget(self,
                                              action: #selector(KeyboardViewController.playOtherKeySound),
                                              for: .touchDown)
                        case Key.KeyType.space, Key.KeyType.return:
                            keyView.addTarget(self,
                                              action: #selector(KeyboardViewController.playOtherKeySound),
                                              for: .touchDown)
                        default:
                            break
                        }
                        
                        if key.isCharacter {
                            if UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.pad {
                                keyView.addTarget(self,
                                                  action: #selector(KeyboardViewController.showPopup(_:)),
                                                  for: [.touchDown, .touchDragInside, .touchDragEnter])
                                keyView.addTarget(keyView,
                                                  action: #selector(KeyboardKey.hidePopup),
                                                  for: [.touchDragExit, .touchCancel])
                                keyView.addTarget(self,
                                                  action: #selector(KeyboardViewController.hidePopupDelay(_:)),
                                                  for: [.touchUpInside, .touchUpOutside, .touchDragOutside])
                                keyView.addTarget(self,
                                                  action: #selector(KeyboardViewController.playCharacterKeySound),
                                                  for: .touchDown)
                            }
                        }
                        
                        if key.hasOutput {
                            keyView.addTarget(self,
                                              action: #selector(KeyboardViewController.keyPressedHelper(_:)),
                                              for: .touchUpInside)
                        }
                        
                        if key.type != Key.KeyType.shift && key.type != Key.KeyType.modeChange {
                            keyView.addTarget(self,
                                              action: #selector(KeyboardViewController.highlightKey(_:)),
                                              for: [.touchDown, .touchDragInside, .touchDragEnter])
                            keyView.addTarget(self,
                                              action: #selector(KeyboardViewController.unHighlightKey(_:)),
                                              for: [.touchUpInside, .touchUpOutside, .touchDragOutside, .touchDragExit, .touchCancel])
                        }
                    }
                }
            }
        }
    }
    
    /////////////////
    // POPUP DELAY //
    /////////////////
    
    var keyWithDelayedPopup: KeyboardKey?
    var popupDelayTimer: Timer?
    
    @objc func showPopup(_ sender: KeyboardKey) {
        if sender == self.keyWithDelayedPopup {
            self.popupDelayTimer?.invalidate()
        }
        sender.showPopup()
    }
    
    @objc func hidePopupDelay(_ sender: KeyboardKey) {
        self.popupDelayTimer?.invalidate()
        
        if sender != self.keyWithDelayedPopup {
            self.keyWithDelayedPopup?.hidePopup()
            self.keyWithDelayedPopup = sender
        }
        
        if sender.popup != nil {
            self.popupDelayTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(KeyboardViewController.hidePopupCallback), userInfo: nil, repeats: false)
        }
    }
    
    @objc func hidePopupCallback() {
        self.keyWithDelayedPopup?.hidePopup()
        self.keyWithDelayedPopup = nil
        self.popupDelayTimer = nil
    }
    
    /////////////////////
    // POPUP DELAY END //
    /////////////////////
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    func contextChanged() {
        self.updateCapsIfNeeded()
        self.autoPeriodState = .noSpace
    }
    
    func setHeight(_ height: CGFloat) {
        if self.heightConstraint == nil {
            self.heightConstraint = NSLayoutConstraint(
                item:self.view as Any,
                attribute:NSLayoutConstraint.Attribute.height,
                relatedBy:NSLayoutConstraint.Relation.equal,
                toItem:nil,
                attribute:NSLayoutConstraint.Attribute.notAnAttribute,
                multiplier:0,
                constant:height)
            self.heightConstraint!.priority = UILayoutPriority(rawValue: 1000)
            
            self.view.addConstraint(self.heightConstraint!) // TODO: what if view already has constraint added?
        }
        else {
            self.heightConstraint?.constant = height
        }
    }
    
    func updateAppearances(_ appearanceIsDark: Bool) {
        self.layout?.solidColorMode = self.solidColorMode()
        self.layout?.darkMode = appearanceIsDark
        self.layout?.updateKeyAppearance()
        
    }
    
    @objc func highlightKey(_ sender: KeyboardKey) {
        sender.isHighlighted = true
    }
    
    @objc func unHighlightKey(_ sender: KeyboardKey) {
        sender.isHighlighted = false
    }
    
    @objc func keyPressedHelper(_ sender: KeyboardKey) {
        if let model = self.layout?.keyForView(sender) {
            self.keyPressed(model)

            // auto exit from special char subkeyboard
            if shiftState != .locked && (model.type == Key.KeyType.space || model.type == Key.KeyType.return || model.type == Key.KeyType.backspace) {
                self.currentMode = 0
            }
            else if model.lowercaseOutput == "'" && shiftState != .locked {
                self.currentMode = 0
            }
            else if model.type == Key.KeyType.character && shiftState != .locked {
                self.currentMode = 0
            }
        }
        
        self.updateCapsIfNeeded()
    }

    // MARK: - Auto Period Not need in Shan Language, Leave for other language
//    func handleAutoPeriod(_ key: Key) {
//        if !UserDefaults.standard.bool(forKey: kPeriodShortcut) {
//            return
//        }
//
//        if self.autoPeriodState == .firstSpace {
//            if key.type != Key.KeyType.space {
//                self.autoPeriodState = .noSpace
//                return
//            }
//
//            let charactersAreInCorrectState = { () -> Bool in
//                let previousContext = self.textDocumentProxy.documentContextBeforeInput
//
//                if previousContext == nil || (previousContext!).count < 3 {
//                    return false
//                }
//
//                var index = previousContext!.endIndex
//
//                index = previousContext!.index(before: index)
//                if previousContext![index] != " " {
//                    return false
//                }
//
//                index = previousContext!.index(before: index)
//                if previousContext![index] != " " {
//                    return false
//                }
//
//                index = previousContext!.index(before: index)
//                let char = previousContext![index]
//                if self.characterIsWhitespace(char) || self.characterIsPunctuation(char) || char == "," {
//                    return false
//                }
//
//                return true
//            }()
//
//            if charactersAreInCorrectState {
//                self.textDocumentProxy.deleteBackward()
//                self.textDocumentProxy.deleteBackward()
//                self.textDocumentProxy.insertText(".")
//                self.textDocumentProxy.insertText(" ")
//            }
//
//            self.autoPeriodState = .noSpace
//        }
//        else {
//            if key.type == Key.KeyType.space {
//                self.autoPeriodState = .firstSpace
//            }
//        }
//    }
    
    // MARK: - Backspace
    
    func cancelBackspaceTimers() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.backspaceLongGTimer?.invalidate()
        self.backspaceLongGTimer = nil
        self.backspaceDelayTimer?.invalidate()
        self.backspaceDelayTimer = nil
        self.backspaceRepeatTimer?.invalidate()
        self.backspaceRepeatTimer = nil
    }
    
    @objc func backspaceDown(_ sender: KeyboardKey) {
        
        (sender.shape as? BackspaceShape)?.backSpaceDown = true
        
        self.textDocumentProxy.deleteBackward()
        self.playBackSpaceKeySound()
    }
    
    @objc func backspaceUp(_ sender: KeyboardKey) {
        
        (sender.shape as? BackspaceShape)?.backSpaceDown = false
        
        self.cancelBackspaceTimers()
    }
    
    @objc func handleBackspaceLongPress(_ sender: KeyboardKey) {
        
        (sender.shape as? BackspaceShape)?.backSpaceDown = true
        
        // trigger for subsequent deletes
        self.backspaceDelayTimer = Timer.scheduledTimer(timeInterval: backspaceDelay - backspaceRepeat, target: self, selector: #selector(KeyboardViewController.backspaceDelayCallback), userInfo: nil, repeats: false)
    }
    
    @objc func backspaceDelayCallback() {
        
        // trigger for repeat deletes
        self.backspaceRepeatTimer = Timer.scheduledTimer(timeInterval: backspaceRepeat, target: self, selector: #selector(KeyboardViewController.backspaceRepeatCallback), userInfo: nil, repeats: true)
        
        perform(#selector(handleDeleteWords), with: nil, afterDelay: 2.0)
    }
    
    @objc func backspaceRepeatCallback() {
        if let documentContextBeforeInput = self.textDocumentProxy.documentContextBeforeInput as NSString? {
            if documentContextBeforeInput.length > 0 {
                self.textDocumentProxy.deleteBackward()
                //self.updateCapsIfNeeded()
                self.playBackSpaceKeySound()
            }
        }
    }
    
    @objc func handleDeleteWords() {
        self.backspaceDelayTimer?.invalidate()
        self.backspaceDelayTimer = nil
        self.backspaceRepeatTimer?.invalidate()
        self.backspaceRepeatTimer = nil
        
        // trigger after 3 second
        self.backspaceLongGTimer = Timer.scheduledTimer(timeInterval: self.backspaceLongG, target: self, selector: #selector(KeyboardViewController.backspaceLongGCallback), userInfo: nil, repeats: true)
    }
    
    @objc func backspaceLongGCallback() {
        
        // TODO: Figure out an implementation that doesn't use bridgeToObjectiveC, in case of funny unicode characters.
        if let documentContextBeforeInput = self.textDocumentProxy.documentContextBeforeInput as NSString? {
            if documentContextBeforeInput.length > 0 {
                var charactersToDelete = 0
                switch documentContextBeforeInput {
                case let s where NSCharacterSet.letters.contains(Unicode.Scalar(s.character(at: s.length - 1))!): // Cursor in front of letter, so delete up to first non-letter character.
                    let range = documentContextBeforeInput.rangeOfCharacter(from: NSCharacterSet.letters.inverted, options: .backwards)
                    if range.location != NSNotFound {
                        charactersToDelete = documentContextBeforeInput.length - range.location - 1
                    } else {
                        charactersToDelete = documentContextBeforeInput.length
                    }
                case let s where s.hasSuffix(" "): // Cursor in front of whitespace, so delete up to first non-whitespace character.
                    let range = documentContextBeforeInput.rangeOfCharacter(from: NSCharacterSet.whitespaces.inverted, options: .backwards)
                    if range.location != NSNotFound {
                        charactersToDelete = documentContextBeforeInput.length - range.location - 1
                    } else {
                        charactersToDelete = documentContextBeforeInput.length
                    }
                default: // Just delete last character.
                    charactersToDelete = 1
                }

                for _ in 0..<charactersToDelete {
                    textDocumentProxy.deleteBackward()
                }
                
                self.playBackSpaceKeySound()
            }
        }
    }
    
    @objc func shiftDown(_ sender: KeyboardKey) {
        self.shiftStartingState = self.shiftState
        
        if let shiftStartingState = self.shiftStartingState {
            if shiftStartingState.uppercase() {
                // handled by shiftUp
                return
            }
            else {
                switch self.shiftState {
                case .disabled:
                    self.shiftState = .enabled
                    self.setMode(1)
                case .enabled:
                    self.shiftState = .disabled
                    self.setMode(1)
                case .locked:
                    self.shiftState = .disabled
                    self.setMode(0)
                }
                
               (sender.shape as? ShiftShape)?.withLock = false
            }
        }
    }
    
    @objc func shiftUp(_ sender: KeyboardKey) {
        
        if self.shiftWasMultitapped {
            // do nothing
        }
        else {
            if let shiftStartingState = self.shiftStartingState {
                if !shiftStartingState.uppercase() {
                    // handled by shiftDown
                }
                else {
                    switch self.shiftState {
                    case .disabled:
                        self.shiftState = .enabled
                        self.setMode(1)
                    case .enabled:
                        self.shiftState = .disabled
                        self.setMode(0)
                    case .locked:
                        self.shiftState = .disabled
                        self.setMode(0)
                    }
                    
                   (sender.shape as? ShiftShape)?.withLock = false
                }
            }
        }

        self.shiftStartingState = nil
        self.shiftWasMultitapped = false
    }
    
    @objc func shiftDoubleTapped(_ sender: KeyboardKey) {
        self.shiftWasMultitapped = true
        
        switch self.shiftState {
        case .disabled:
            self.shiftState = .locked
            self.setMode(1)
        case .enabled:
            self.shiftState = .locked
            self.setMode(1)
        case .locked:
            self.shiftState = .disabled
            self.setMode(0)
        }
    }
    
    func updateKeyCaps(_ uppercase: Bool) {
        let characterUppercase = (UserDefaults.standard.bool(forKey: kSmallLowercase) ? uppercase : true)
        self.layout?.updateKeyCaps(false, uppercase: uppercase, characterUppercase: characterUppercase, shiftState: self.shiftState)
        
        // MARK: - call update return key
    }
    
    func updateReturnKeyText(_ returnKeyType: UIReturnKeyType) {
        self.layout?.updateReturnKeyText(returnKeyType)
        self.layout?.returnKeyType = returnKeyType
    }
    
    @objc func modeChangeTapped(_ sender: KeyboardKey) {
        if let toMode = self.layout?.viewToModel[sender]?.toMode {
            self.currentMode = toMode
            self.shiftState = self.shiftStartingState ?? .disabled
        }
    }
    
    func setMode(_ mode: Int) {
        self.forwardingView.resetTrackedViews()
        self.shiftStartingState = nil
        self.shiftWasMultitapped = false
        self.currentMode = mode
        
        let uppercase = self.shiftState.uppercase()
        let characterUppercase = (UserDefaults.standard.bool(forKey: kSmallLowercase) ? uppercase : true)
        self.layout?.layoutKeys(mode, uppercase: uppercase, characterUppercase: characterUppercase, shiftState: self.shiftState, needsInputModeSwitchKey: self.needsInputModeSwitchKey)
        
        self.setupKeys()
    }
    
    func updateCapsIfNeeded() {
            switch self.shiftState {
            case .disabled:
                self.shiftState = .disabled
            case .enabled:
                self.shiftState = .disabled
            case .locked:
                self.shiftState = .locked
            }
    }
    
    func characterIsPunctuation(_ character: Character) -> Bool {
        return (character == ".") || (character == "!") || (character == "?")
    }
    
    func characterIsNewline(_ character: Character) -> Bool {
        return (character == "\n") || (character == "\r")
    }
    
    func characterIsWhitespace(_ character: Character) -> Bool {
        // there are others, but who cares
        return (character == " ") || (character == "\n") || (character == "\r") || (character == "\t")
    }
    
    func stringIsWhitespace(_ string: String?) -> Bool {
        if string != nil {
            for char in (string!) {
                if !characterIsWhitespace(char) {
                    return false
                }
            }
        }
        return true
    }
    
    // MARK: - Key Sound
    
    //    Press Click - ID: 1104
    //    Press Delete - ID: 1155
    //    Press Modifier - ID: 1156
    
    @objc func playCharacterKeySound() {
        AudioServicesPlaySystemSound(1104);
    }
    
    @objc func playBackSpaceKeySound() {
        AudioServicesPlaySystemSound(1155);
    }
    
    @objc func playOtherKeySound() {
        AudioServicesPlaySystemSound(1156);
    }

    
    //////////////////////////////////////
    // MOST COMMONLY EXTENDABLE METHODS //
    //////////////////////////////////////
    
    class var layoutClass: KeyboardLayout.Type { get { return KeyboardLayout.self }}
    class var layoutConstants: LayoutConstants.Type { get { return LayoutConstants.self }}
    class var globalColors: GlobalColors.Type { get { return GlobalColors.self }}
    
    func keyPressed(_ key: Key) {
        self.textDocumentProxy.insertText(key.outPutForCase(self.shiftState.uppercase()))
    }
}

