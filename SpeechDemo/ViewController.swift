//
//  ViewController.swift
//  SpeechDemo
//
//  Created by Pavel Gnatyuk on 30/12/2018.
//  Copyright © 2018 Viber Media S.A.R.L. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var buttonTalk: UIButton!
    @IBOutlet weak var buttonClear: UIButton!
    @IBOutlet weak var textFieldLanguage: UITextField!
    
    let audioEngine = AVAudioEngine()
    
    var speechRecognizer: SFSpeechRecognizer?
    var request:SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    
    var language: String {
        var language: String = Locale.preferredLanguages.first ?? ""
        if let current = textFieldLanguage.textInputMode?.primaryLanguage {
            language = current
        }
        return language
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardTypeDidChange(notification:)), name: UITextInputMode.currentInputModeDidChangeNotification, object: nil)

        buttonTalk.isEnabled = false
        textFieldLanguage.text = language
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch SFSpeechRecognizer.authorizationStatus() {
        case .notDetermined:
            askSpeechPermission()
            
        case .authorized:
            self.buttonTalk.isEnabled = true
            
        case .denied, .restricted:
            self.buttonTalk.isEnabled = false
        }
    }

    @IBAction func buttonClearClicked(_ sender: Any) {
        textView.text = ""
    }
    
    @IBAction func buttonTalkClicked(_ sender: Any) {
        textView.text = ""
        startListening()
    }
    
    @IBAction func buttonStopClicked(_ sender: Any) {
        request?.endAudio()
        stopListening()
    }
    
    func askSpeechPermission() {
        SFSpeechRecognizer.requestAuthorization { status in
            OperationQueue.main.addOperation {
                switch status {
                case .authorized:
                    self.buttonTalk.isEnabled = true
                default:
                    self.buttonTalk.isEnabled = false
                }
            }
        }
    }

    @objc func keyboardTypeDidChange(notification: Notification) {
        textFieldLanguage.text = language
    }

    func startListening() {
        debugPrint("\(#function)")
        
        // Stop the pervious session if it is still running.
        stopListening()
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .spokenAudio, options: [.interruptSpokenAudioAndMixWithOthers])
            try audioSession.setMode(.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        } catch  {
            debugPrint("Audio session initialization error: \(error.localizedDescription)")
        }
        
        let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, time) in
            self.request?.append(buffer)
        }
        
        request = SFSpeechAudioBufferRecognitionRequest()
        guard let request = request else {
            stopListening()
            return
        }
        request.shouldReportPartialResults = true

        debugPrint("language: \(language)")
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: language))
        guard let recognizer = speechRecognizer else {
            assert(false, "Failed to create the speech recognizer")
            return
        }

        recognitionTask = recognizer.recognitionTask(with: request, resultHandler: { (result, error) in
            var isFinal = false
            
            if let result = result {
                self.textView.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.stopListening()
            }
        })
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        }
        catch {
            debugPrint("Error: \(error)")
        }
    }
    
    func stopListening() {
        debugPrint("\(#function)")

        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)

        recognitionTask?.cancel()
        recognitionTask = nil
        request = nil
    }
}

