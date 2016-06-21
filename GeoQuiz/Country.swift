//
//  Country.swift
//  GeoQuiz
//
//  Created by Jarrod Parkes on 6/21/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import Foundation

// MARK: - Country

class Country {
    
    // MARK: Properties
    
    var languageCode: String
    var languageName: String
    var textToSpeak: String
    var flagName: String
  
    // MARK: Initializers
    
    init() {
        languageCode = ""
        languageName = ""
        textToSpeak = ""
        flagName = ""
    }
  
    init(name: String, bcp47Code: String, textToRead: String, flagImageName: String) {
        languageName = name
        languageCode = bcp47Code
        textToSpeak = textToRead
        flagName = flagImageName
    }
}