//
//  QuizViewController+Functions.swift
//  GeoQuiz
//
//  Created by Jarrod Parkes on 6/21/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

// MARK: - QuizViewController (Functions)

extension QuizViewController {
  
    // MARK: QuizState
    
    enum QuizState {
        case noQuestionUpYet, playingAudio, questionDisplayed, readyToSpeak
    }
    
    // MARK: Actions
    
    @IBAction func hearPhrase(_ sender: UIButton) {
        // This function runs to code for when the button says "Hear Phrase" or when it says Stop.
        // The first check is to see if we are speaking, in which case the button would have been labeled STOP
        // If iOS is currently speaking we tell it to stop and reset the buttons
        if currentState == .playingAudio {
            stopAudio()
            resetButtonToState(.readyToSpeak)
        } else if currentState == .noQuestionUpYet {
            // no Question so choose a language and question
            chooseNewLanguageAndSetupButtons()
            speak(spokenText, languageCode: bcpCode)
        } else if currentState == .questionDisplayed || currentState == .readyToSpeak {
            // Flags are up so just replay the audio
            speak(spokenText, languageCode: bcpCode)
        }
    }
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        resetButtonToState(.noQuestionUpYet)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLanguages()
    }
    
    // MARK: Speak
    
    func speak(_ stringToSpeak: String, languageCode: String) {
        // Grab the Speech Synthesizer and set the language and text to speak
        // Tell it to call this ViewController back when it has finished speaking
        // Tell it to start speaking.
        // Finally, set the "Hear Phrase" button to say "Stop" instead
        speechSynth.stopSpeaking(at: AVSpeechBoundary.immediate)
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: stringToSpeak)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: languageCode)
        speechSynth.delegate = self
        speechSynth.speak(speechUtterance)
        resetButtonToState(.playingAudio)
    }
    
    func stopAudio() {
        // Stops the audio playback
        speechSynth.stopSpeaking(at: AVSpeechBoundary.immediate)
    }

    // MARK: Setup/Reset
    
    func setupLanguages() {
        
        var tempCountry = Country()
        
        // Czech Language
        tempCountry = Country(name: "Czech", bcp47Code: "cs-CZ", textToRead: "Učení je celoživotní výkon.", flagImageName: "czechFlag")
        languageChoices.append(tempCountry)
        
        // Danish Language
        tempCountry = Country(name: "Danish", bcp47Code: "da-DK", textToRead: "Læring er en livslang stræben.", flagImageName: "denmarkFlag")
        languageChoices.append(tempCountry)
        
        // German Language
        tempCountry = Country(name: "German", bcp47Code: "de-DE", textToRead: "Lernen ist ein lebenslanger Verfolgung.", flagImageName: "germanyFlag")
        languageChoices.append(tempCountry)
        
        // Spanish Language
        tempCountry = Country(name: "Spanish", bcp47Code: "es-ES", textToRead: "El aprendizaje es una búsqueda que dura toda la vida.", flagImageName: "spainFlag")
        languageChoices.append(tempCountry)
        
        // French Language
        tempCountry = Country(name: "French", bcp47Code: "fr-FR", textToRead: "L'apprentissage est une longue quête de la vie.", flagImageName: "franceFlag")
        languageChoices.append(tempCountry)
        
        // Polish Language
        tempCountry = Country(name: "Polish", bcp47Code: "pl-PL", textToRead: "Uczenie się przez całe życie pościg.", flagImageName: "polandFlag")
        languageChoices.append(tempCountry)
        
        // English Language
        tempCountry = Country(name: "English", bcp47Code: "en-US", textToRead: "Learning is a life long pursuit.", flagImageName: "unitedStatesFlag")
        languageChoices.append(tempCountry)
        
        // Portuguese Language
        tempCountry = Country(name: "Portuguese", bcp47Code: "pt-BR", textToRead: "A aprendizagem é um longa busca que dura toda a vida.", flagImageName: "brazilFlag")
        languageChoices.append(tempCountry)
        
    }

    func chooseNewLanguageAndSetupButtons() {
        // 1. Choose the location of the correct answer
        // 2. Choose the language of the correct answer
        // 3. Choose the language of the other 2 answers (incorrect answers) array randomItem
        
        resetButtonToState(.readyToSpeak)
        // 1.
        let randomChoiceLocation = arc4random_uniform(UInt32(3))
        var button1: UIButton!
        var button2: UIButton!
        var button3: UIButton!
        
        if (randomChoiceLocation == 0) {
            print("Debug: Correct answer in the first, top button")
            button1 = flagButton1
            button2 = flagButton2
            button3 = flagButton3
            correctButtonTag = 0
        } else if (randomChoiceLocation == 1) {
            print("Debug: Correct answer is in the middle button")
            button1 = flagButton2
            button2 = flagButton1
            button3 = flagButton3
            correctButtonTag = 1
        } else {
            print("Debug: Correct answer is in the bottom button")
            button1 = flagButton3
            button2 = flagButton2
            button3 = flagButton1
            correctButtonTag = 2
        }
        
        // use vars button1-3 to assign the text.
        let randomLanguage = arc4random_uniform(UInt32(self.languageChoices.count))
        let randomLanguageInt = Int(randomLanguage)
        let correctCountry = languageChoices[randomLanguageInt]
        
        let languageTitle = correctCountry.languageName
        bcpCode = correctCountry.languageCode
        spokenText = correctCountry.textToSpeak
        //languageTitle = languageTitle + "CR"
        let button1Flag = correctCountry.flagName
        button1.setTitle(languageTitle, for: UIControlState())
        button1.setBackgroundImage(UIImage(named: button1Flag), for: UIControlState())
        
        var otherChoicesArray = languageChoices
        otherChoicesArray.remove(at: randomLanguageInt)
        
        let secondRandomLanguage = arc4random_uniform(UInt32(otherChoicesArray.count))
        let secondRandomLanguageInt = Int(secondRandomLanguage)
        let alternateCountry1 = otherChoicesArray[secondRandomLanguageInt]
        
        let secondLanguageTitle = alternateCountry1.languageName
        button2.setTitle(secondLanguageTitle, for: UIControlState())
        
        let button2Flag = alternateCountry1.flagName
        button2.setBackgroundImage(UIImage(named: button2Flag), for: UIControlState())
        
        otherChoicesArray.remove(at: secondRandomLanguageInt)
        
        let thirdRandomLanguage = arc4random_uniform(UInt32(otherChoicesArray.count))
        let thirdRandomLanguageInt = Int(thirdRandomLanguage)
        let alternateCountry2 = otherChoicesArray[thirdRandomLanguageInt]
        
        let thirdLanguageTitle = alternateCountry2.languageName
        button3.setTitle(thirdLanguageTitle, for: UIControlState())
        let button3Flag = alternateCountry2.flagName
        button3.setBackgroundImage(UIImage(named: button3Flag), for: UIControlState())
        otherChoicesArray.remove(at: thirdRandomLanguageInt)
    }
    
    func resetButtonToState(_ newState: QuizState) {
        if newState == .noQuestionUpYet {
            flagButton1.isHidden = true
            flagButton2.isHidden = true
            flagButton3.isHidden = true
            flagButton1.layer.borderColor = UIColor.black().cgColor
            flagButton1.layer.borderWidth = 5
            flagButton2.layer.borderColor = UIColor.black().cgColor
            flagButton2.layer.borderWidth = 5
            flagButton3.layer.borderColor = UIColor.black().cgColor
            flagButton3.layer.borderWidth = 5
            repeatPhraseButton.setTitle("Start Quiz", for: UIControlState())
        } else if newState == .readyToSpeak {
            repeatPhraseButton.setTitle("Hear Phrase", for: UIControlState())
        } else if newState == .questionDisplayed {
            repeatPhraseButton.setTitle("Hear Phrase Again", for: UIControlState())
        } else if newState == .playingAudio {
            flagButton1.isHidden = false
            flagButton2.isHidden = false
            flagButton3.isHidden = false
            repeatPhraseButton.setTitle("Stop", for: UIControlState())
        }
        currentState = newState
    }
    
    // MARK: Alerts
    
    func resetQuiz(_ alert: UIAlertAction!) {
        chooseNewLanguageAndSetupButtons()
        resetButtonToState(.readyToSpeak)
    }
  
    func displayAlert(_ messageTitle: String, messageText: String) {
        stopAudio()
        let alert = UIAlertController(title: messageTitle, message:messageText, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: resetQuiz))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - QuizViewController: AVSpeechSynthesizerDelegate

extension QuizViewController: AVSpeechSynthesizerDelegate {

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        resetButtonToState(.questionDisplayed)
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        resetButtonToState(.questionDisplayed)
    }
}
