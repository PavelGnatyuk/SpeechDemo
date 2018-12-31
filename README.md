# SpeechDemo

The app is a simplem demo for the speech recognition:
1. Add descriptions to the info.plist
2. Check permissions on the app start
3. Create audio engine and the speech recognition instances.
4. Each time on the start initialize the recognition request and the task.
5. Destroy the recognition request and the task in the end (or before the new start).

### Reference
1. [WWDC 2016 - Session 509 - iOS](https://developer.apple.com/videos/play/wwdc2016/509)
2. [Working Apple sample](https://developer.apple.com/library/archive/samplecode/SpeakToMe/Listings/SpeakToMe_ViewController_swift.html#//apple_ref/doc/uid/TP40017110-SpeakToMe_ViewController_swift-DontLinkElementID_6)
3. [Using the Speech Recognition API in iOS 10](https://code.tutsplus.com/tutorials/using-the-speech-recognition-api-in-ios-10--cms-28032)

### Notes
1. The app works much better with:

```SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))```

instead of

```SFSpeechRecognizer? = SFSpeechRecognizer()```

2. Audio session is initilized so:
```try audioSession.setCategory(.record, mode: .spokenAudio, options: [.interruptSpokenAudioAndMixWithOthers])```

3. An error with initialization of the Audio session:

`2018-12-31 07:13:50.498942+0200 SpeechDemo[6772:2783016] [avas] AVAudioSessionPortImpl.mm:56:ValidateRequiredFields: Unknown selected data source for Port Receiver (type: Receiver)`

