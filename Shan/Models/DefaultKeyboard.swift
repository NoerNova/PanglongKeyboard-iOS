//
//  DefaultKeyboard.swift
//  Shan
//
//  Created by NorHsangPha BoonHse on 7/5/2564 BE.
//

func defaultKeyboard() -> Keyboard {
    let defaultKeyboard = Keyboard()
    
    // MARK: - Mode 0
    
    for key in ["ၸ", "တ", "ၼ", "မ", "ဢ", "ပ", "ၵ", "င", "ဝ", "ႁ"] {
        let keyModel = Key(.character)
        keyModel.setLetter(key)
        defaultKeyboard.add(key: keyModel, row: 0, page: 0)
    }
    
    for key in ["ေ", "ႄ", "ိ", "်", "ွ", "ႉ", "ႇ", "ု", "ူ", "ႈ"] {
        let keyModel = Key(.character)
        keyModel.setLetter(key)
        defaultKeyboard.add(key: keyModel, row: 1, page: 0)
    }
    
    let shiftKey = Key(.shift)
    shiftKey.type = .shift
    defaultKeyboard.add(key: shiftKey, row: 2, page: 0)
    
    for key in ["ၽ", "ထ", "ၶ", "လ", "ယ", "ၺ", "ၢ", "။"] {
        let keyModel = Key(.character)
        keyModel.setLetter(key)
        defaultKeyboard.add(key: keyModel, row: 2, page: 0)
    }
    
    let backspace = Key(.backspace)
    defaultKeyboard.add(key: backspace, row: 2, page: 0)
    
    let keyModeChangeNumbers = Key(.modeChange)
    keyModeChangeNumbers.uppercaseKeyCap = "123"
    keyModeChangeNumbers.toMode = 2
    defaultKeyboard.add(key: Key(keyModeChangeNumbers), row: 3, page: 0)
    
    let keyboardChange = Key(.keyboardChange)
    defaultKeyboard.add(key: keyboardChange, row: 3, page: 0)
    
    let space = Key(.space)
    space.uppercaseKeyCap = "ပဝ်ႇ"
    space.uppercaseOutput = " "
    space.lowercaseOutput = " "
    defaultKeyboard.add(key: space, row: 3, page: 0)
    
    let returnKey = Key(.return)
    returnKey.uppercaseKeyCap = "return"
    returnKey.uppercaseOutput = "\n"
    returnKey.lowercaseOutput = "\n"
    defaultKeyboard.add(key: returnKey, row: 3, page: 0)
    
    
    // MARK: - Mode 1
    
    for key in ["ၹ", "ၻ", "ꧣ", "႞", "ြ", "ၿ", "ၷ", "ရ", "သ", "ႀ"] {
        let keyModel = Key(.character)
        keyModel.setLetter(key)
        defaultKeyboard.add(key: keyModel, row: 0, page: 1)
    }
    
    for key in ["ဵ", "ႅ", "ီ", "ႂ်", "ႂ", "့", "ႆ", "ꧦ", "ႊ", "း"] {
        let keyModel = Key(.character)
        keyModel.setLetter(key)
        defaultKeyboard.add(key: keyModel, row: 1, page: 1)
    }
    
    let shiftKey2 = Key(.shift)
    shiftKey2.type = .shift
    defaultKeyboard.add(key: shiftKey2, row: 2, page: 1)
    
    for key in ["ၾ", "ၻ", "ꧠ", "ꩮ", "ျ", "႟", "ႃ", "၊"] {
        let keyModel = Key(.character)
        keyModel.setLetter(key)
        defaultKeyboard.add(key: Key(keyModel), row: 2, page: 1)
    }
    
    
    defaultKeyboard.add(key: Key(backspace), row: 2, page: 1)
    
    defaultKeyboard.add(key: Key(keyModeChangeNumbers), row: 3, page: 1)
    
    defaultKeyboard.add(key: Key(keyboardChange), row: 3, page: 1)
    
    defaultKeyboard.add(key: Key(space), row: 3, page: 1)
    
    defaultKeyboard.add(key: Key(returnKey), row: 3, page: 1)
    
    
    // MARK: - Mode 2

    
    for key in ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"] {
        let keyModel = Key(.specialCharacter)
        keyModel.setLetter(key)
        defaultKeyboard.add(key: keyModel, row: 0, page: 2)
    }
    
    for key in ["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""] {
        let keyModel = Key(.specialCharacter)
        keyModel.setLetter(key)
        defaultKeyboard.add(key: keyModel, row: 1, page: 2)
    }
    
    let keyModeChangeSpecialCharacters = Key(.modeChange)
    keyModeChangeSpecialCharacters.uppercaseKeyCap = "#+="
    keyModeChangeSpecialCharacters.toMode = 3
    defaultKeyboard.add(key: keyModeChangeSpecialCharacters, row: 2, page: 2)
    
    for key in [".", ",", "?", "!", "'"] {
        let keyModel = Key(.specialCharacter)
        keyModel.setLetter(key)
        defaultKeyboard.add(key: keyModel, row: 2, page: 2)
    }
    
    defaultKeyboard.add(key: Key(backspace), row: 2, page: 2)
    
    let keyModeChangeLetters = Key(.modeChange)
    keyModeChangeLetters.uppercaseKeyCap = "ၵၶင"
    keyModeChangeLetters.toMode = 0
    defaultKeyboard.add(key: keyModeChangeLetters, row: 3, page: 2)
    
    defaultKeyboard.add(key: Key(keyboardChange), row: 3, page: 2)
    
    defaultKeyboard.add(key: Key(space), row: 3, page: 2)
    
    defaultKeyboard.add(key: Key(returnKey), row: 3, page: 2)
    
    // MARK: - Mode 3
    
    for key in ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="] {
        let keyModel = Key(.specialCharacter)
        keyModel.setLetter(key)
        defaultKeyboard.add(key: keyModel, row: 0, page: 3)
    }
    
    for key in ["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "•"] {
        let keyModel = Key(.specialCharacter)
        keyModel.setLetter(key)
        defaultKeyboard.add(key: keyModel, row: 1, page: 3)
    }
    
    defaultKeyboard.add(key: Key(keyModeChangeNumbers), row: 2, page: 3)
    
    for key in ["x", "÷",".", ",", "?", "!", "'"] {
        let keyModel = Key(.specialCharacter)
        keyModel.setLetter(key)
        defaultKeyboard.add(key: keyModel, row: 2, page: 3)
    }
    
    defaultKeyboard.add(key: Key(backspace), row: 2, page: 3)
    
    defaultKeyboard.add(key: Key(keyModeChangeLetters), row: 3, page: 3)
    
    defaultKeyboard.add(key: Key(keyboardChange), row: 3, page: 3)
    
    defaultKeyboard.add(key: Key(space), row: 3, page: 3)
    
    defaultKeyboard.add(key: Key(returnKey), row: 3, page: 3)
    
    return defaultKeyboard
}

