//
//  ViewController.swift
//  SpeechDemo
//
//  Created by Pavel Gnatyuk on 30/12/2018.
//  Copyright © 2018 Viber Media S.A.R.L. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController, SFSpeechRecognizerDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var buttonTalk: UIButton!
    @IBOutlet weak var buttonClear: UIButton!
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    var request:SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.buttonTalk.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        speechRecognizer?.delegate = self
        
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
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        debugPrint("Available: \(available)")
        
        if !available {
            let alert = UIAlertController(title: "There was a problem accessing the recognizer", message: "Please try again later", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    func startListening() {
        debugPrint("\(#function)")
        
        // Stop the pervious session if it is still running.
        stopListening()

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .mixWithOthers)
            try audioSession.setMode(.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        } catch  {
            debugPrint("Audio session initialization error: \(error)")
        }

        request = SFSpeechAudioBufferRecognitionRequest()
        guard let request = request else {
            return
        }
        request.shouldReportPartialResults = true

        let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, time) in
            self.request?.append(buffer)
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
        }
        catch {
            debugPrint("Error: \(error)")
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
            var isFinal = false
            
            if let result = result {
                self.textView.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.stopListening()
            }
        })
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

