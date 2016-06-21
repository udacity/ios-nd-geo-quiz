//
//  QuizViewController.swift
//  GeoQuiz
//
//  Created by Jarrod Parkes on 6/21/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: - QuizViewController: UIViewController

class QuizViewController: UIViewController {
  
    // MARK: Outlets
    
    @IBOutlet weak var flagButton1: UIButton!
    @IBOutlet weak var flagButton2: UIButton!
    @IBOutlet weak var flagButton3: UIButton!
    @IBOutlet weak var repeatPhraseButton: UIButton!
  
    // MARK: Properties
    
    var languageChoices = [Country]()
    var lastRandomLanguageID = -1
    var selectedRow = -1
    var correctButtonTag = -1
    var currentState: QuizState = .NoQuestionUpYet
    var spokenText = ""
    var bcpCode = ""
    let speechSynth = AVSpeechSynthesizer()
    
    // MARK: Actions
    
    // This function is called when user presses a flag button.
    @IBAction func flagButtonPressed(sender: UIButton) {

        // TODO: Add code to display a message to the user telling them whether or not they guessed correctly.
    }
}