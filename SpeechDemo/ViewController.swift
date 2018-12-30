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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func buttonClearClicked(_ sender: Any) {
        textView.text = ""
    }
    
    @IBAction func buttonTalkClicked(_ sender: Any) {
        textView.text += " Text for a test "
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        debugPrint("Available: \(available)")
    }
}

