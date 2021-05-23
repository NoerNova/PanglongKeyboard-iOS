//
//  DefaultKeyboard.swift
//  Shan
//
//  Created by NorHsangPha BoonHse on 7/5/2564 BE.
//

func defaultKeyboard(_ needsInputModeSwitchKey: Bool) -> Keyboard {
    let defaultKeyboard = Keyboard()
    let needsInputModeSwitchKey = needsInputModeSwitchKey
    
    // MARK: - Mode 0
    
    // ၸ    တ    ၼ    မ    ႄ    ပ    ၵ    င    သ    ၺ
    for key in ["ၸ", "တ", "ၼ", "မ", "ႄ", "ပ", "ၵ", "င", "သ", "ၺ"] {
        let keyModel = Key(.character)
        keyModel.setLetter(key)
        defaultKeyboard.add(key: Key(keyModel), row: 0, page: 0)
    }
    
    //
    for key in ["ေ", "ျ", "ိ", "်", "ႂ", "ႉ", "ႈ", "ု", "ူ", "း"] {
        let keyModel = Key(.character)
        keyModel.setLetter(key)
        defaultKeyboard.add(key: Key(keyModel), row: 1, page: 0)
    }
    
    let shiftKey = Key(.shift)
    defaultKeyboard.add(key: Key(shiftKey), row: 2, page: 0)
    
    // ၽ    ထ    ၶ    လ    ႇ    ဢ    ၢ    ယ
    for key in ["ၽ", "ထ", "ၶ", "လ", "ႇ", "ဢ", "ၢ", "ယ"] {
        let keyModel = Key(.character)
        keyModel.setLetter(key)
        defaultKeyboard.add(key: Key(keyModel), row: 2, page: 0)
    }
    
    let backspace = Key(.backspace)
    defaultKeyboard.add(key: Key(backspace), row: 2, page: 0)
    
    let keyModeChangeNumbers = Key(.modeChange)
    keyModeChangeNumbers.uppercaseKeyCap = "123"
    keyModeChangeNumbers.toMode = 2
    defaultKeyboard.add(key: Key(keyModeChangeNumbers), row: 3, page: 0)
    
    let keyboardChange = Key(.keyboardChange)
    if needsInputModeSwitchKey {
        defaultKeyboard.add(key: Key(keyboardChange), row: 3, page: 0)
    }
    
    let space = Key(.space)
    space.uppercaseKeyCap = "ပဝ်ႇ"
    space.uppercaseOutput = " "
    space.lowercaseOutput = " "
    defaultKeyboard.add(key: Key(space), row: 3, page: 0)
    
    let returnKey = Key(.return)
    returnKey.uppercaseKeyCap = ""
    returnKey.uppercaseOutput = "\n"
    returnKey.lowercaseOutput = "\n"
    defaultKeyboard.add(key: Key(returnKey), row: 3, page: 0)
    
    
    // MARK: - Mode 1
    
    // ၹ    ၻ    ꧣ    ႞    ၿ    ြ    ၷ    ႀ    ဝ    ႁ
    for key in ["ၹ", "ၻ", "ꧣ", "႞", "ၿ", " ြ", "ၷ", "ႀ", "ဝ", "ႁ"] {
        let keyModel = Key(.character)
        keyModel.setLetter(key)
        defaultKeyboard.add(key: Key(keyModel), row: 0, page: 1)
    }
    
    // ဵ   ှ    ီ    ႅ    ႂ်    ံ     ့    ရ    ႟
    for key in ["ဵ", "ှ", "ီ", "ႅ", "ႂ်", "ံ", "့", "ရ", "႟", "ႊ"] {
        let keyModel = Key(.character)
        keyModel.setLetter(key)
        defaultKeyboard.add(key: Key(keyModel), row: 1, page: 1)
    }
    
    defaultKeyboard.add(key: Key(shiftKey), row: 2, page: 1)
    
    // ၾ    ꩪ    ꧠ    ꩮ    ႆ    ႃ    ွ    ၊    ။
    for key in ["ၾ", "ၻ", "ꧠ", "ꩮ", "ႆ", "ွ", "ႃ", "ꧦ"] {
        let keyModel = Key(.character)
        keyModel.setLetter(key)
        defaultKeyboard.add(key: Key(keyModel), row: 2, page: 1)
    }
    
    
    defaultKeyboard.add(key: Key(backspace), row: 2, page: 1)
    
    if needsInputModeSwitchKey {
        defaultKeyboard.add(key: Key(keyModeChangeNumbers), row: 3, page: 1)
    }
    
    defaultKeyboard.add(key: Key(keyboardChange), row: 3, page: 1)
    
    defaultKeyboard.add(key: Key(space), row: 3, page: 1)
    
    defaultKeyboard.add(key: Key(returnKey), row: 3, page: 1)
    
    
    // MARK: - Mode 2
    
    
    for key in ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"] {
        let keyModel = Key(.specialCharacter)
        keyModel.setLetter(key)
        defaultKeyboard.add(key: Key(keyModel), row: 0, page: 2)
    }
    
    for key in ["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""] {
        let keyModel = Key(.specialCharacter)
        keyModel.setLetter(key)
        defaultKeyboard.add(key: Key(keyModel), row: 1, page: 2)
    }
    
    let keyModeChangeSpecialCharacters = Key(.modeChange)
    keyModeChangeSpecialCharacters.uppercaseKeyCap = "#+="
    keyModeChangeSpecialCharacters.toMode = 3
    defaultKeyboard.add(key: Key(keyModeChangeSpecialCharacters), row: 2, page: 2)
    
    for key in [".", ",", "?", "!", "'", "၊", "။"] {
        let keyModel = Key(.specialCharacter)
        keyModel.setLetter(key)
        defaultKeyboard.add(key: Key(keyModel), row: 2, page: 2)
    }
    
    defaultKeyboard.add(key: Key(backspace), row: 2, page: 2)
    
    let keyModeChangeLetters = Key(.modeChange)
    keyModeChangeLetters.uppercaseKeyCap = "ၵၶင"
    keyModeChangeLetters.toMode = 0
    defaultKeyboard.add(key: Key(keyModeChangeLetters), row: 3, page: 2)
    
    if needsInputModeSwitchKey {
        defaultKeyboard.add(key: Key(keyboardChange), row: 3, page: 2)
    }
    
    defaultKeyboard.add(key: Key(space), row: 3, page: 2)
    
    defaultKeyboard.add(key: Key(returnKey), row: 3, page: 2)
    
    // MARK: - Mode 3
    
    for key in ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="] {
        let keyModel = Key(.specialCharacter)
        keyModel.setLetter(key)
        defaultKeyboard.add(key: Key(keyModel), row: 0, page: 3)
    }
    
    for key in ["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "•"] {
        let keyModel = Key(.specialCharacter)
        keyModel.setLetter(key)
        defaultKeyboard.add(key: Key(keyModel), row: 1, page: 3)
    }
    
    defaultKeyboard.add(key: Key(keyModeChangeNumbers), row: 2, page: 3)
    
    for key in ["x", "÷",".", ",", "?", "!", "'"] {
        let keyModel = Key(.specialCharacter)
        keyModel.setLetter(key)
        defaultKeyboard.add(key: Key(keyModel), row: 2, page: 3)
    }
    
    defaultKeyboard.add(key: Key(backspace), row: 2, page: 3)
    
    defaultKeyboard.add(key: Key(keyModeChangeLetters), row: 3, page: 3)
    
    if needsInputModeSwitchKey {
        defaultKeyboard.add(key: Key(keyboardChange), row: 3, page: 3)
    }
    
    defaultKeyboard.add(key: Key(space), row: 3, page: 3)
    
    defaultKeyboard.add(key: Key(returnKey), row: 3, page: 3)
    
    return defaultKeyboard
}
