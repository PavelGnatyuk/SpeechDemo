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
