//
//  TranscriptionViewController.swift
//  NYHM
//
//  Created by Hafizh Mo on 12/06/22.
//

import UIKit
import Speech
import AVKit
import WatchConnectivity

protocol SaveTranscriptionProtocol {
    func reloadTableView()
}

protocol LocationAuthorizationProtocol {
    func onAuthorizationChanged()
}

class TranscriptionViewController: UIViewController, SFSpeechRecognizerDelegate, AVAudioRecorderDelegate, SessionManager, LocationAuthorizationProtocol {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationLabelBottom: UILabel!
    @IBOutlet weak var transcriptionResultTextView: UITextView!
    @IBOutlet weak var transcribeActionButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var waveformView: UIView!
    
    @IBOutlet weak var textViewToTitleConstraint: NSLayoutConstraint!
    @IBOutlet weak var navbar: UINavigationBar!

    @IBOutlet weak var titleToSuperview: NSLayoutConstraint!
    @IBOutlet weak var durationToSuperView: NSLayoutConstraint!
    
    var delegate:SaveTranscriptionProtocol?

    var transcriptionTemp = ""
    var transcriptionTemp2 = ""
    var filename:URL?
    var filenameToSave:String = ""
    var isPlaying:Bool = true

    var durationString:String = ""

    let audioEngine = AVAudioEngine()

    var speechRecognizer: SFSpeechRecognizer?
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?

    var recordingSession: AVAudioSession?
    var audioRecorder: AVAudioRecorder?

    var timer: Timer?
    var durationTemp:Int = 0

    var numberOfChannelForAudio = 2

    let updateInterval = 0.00005
    
    let isWaveformVisible = UserDefaults.standard.bool(forKey: Constants.IS_WAVEFORM_VISIBLE)
    
    lazy var pencil = UIBezierPath(rect: waveformView.bounds)
    lazy var firstPoint = CGPoint (x: waveformView.bounds.maxX, y: waveformView.bounds.midY)
    lazy var space: CGFloat = 2.5
    let waveLayer = CAShapeLayer()
    var amplitudeLength: CGFloat!
    var start: CGPoint!
    var waveformTimer : Timer!
    var waveCounterTimer: CGFloat = 1
    
    var speechIsAuth:Bool?
    var micIsAuth:Bool?

    var locationManager: LocationManager?

    func onAuthorizationChanged() {
        guard let locationManager = locationManager else { return }
        locationManager.lookUpCurrentLocation { placemark in
            if let placemark = placemark {
                self.titleTextField.text = "\(placemark.name ?? "")"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = LocationManager(viewController: self)
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(type(of: self).dataDidFlow(_:)),
            name: .dataDidFlow, object: nil
        )
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(type(of: self).activationDidComplete(_:)),
            name: .activationDidComplete, object: nil
        )
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(type(of: self).reachabilityDidChange(_:)),
            name: .reachabilityDidChange, object: nil
        )
        
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)


        speechRecognizer?.delegate = self
        audioRecorder?.delegate = self
        
        transcriptionResultTextView.text = ""
        
        initSpeechAuth()
        initRecordingSession()
        
        transcribeOnLoad()
        startRecording()
        
        sendStarting([MessageKeyLoad.starting: true])
        turnTheWave(bool: isWaveformVisible)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.titleTextField.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if isWaveformVisible {
            waveformTimer.invalidate()
        }
        delegate?.reloadTableView()
        NotificationCenter.default.removeObserver(self)
    }
    
    func initDuration() -> Void {
        
        durationLabel.text = "00:00:00"
        durationLabelBottom.text = "00:00:00"
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.isPlaying {
                self.durationTemp += 1
                
                self.durationTemp.hmsFrom(seconds: self.durationTemp) { hours, minutes, seconds in
                    let hours = seconds.getStringFrom(seconds: hours)
                    let minutes = seconds.getStringFrom(seconds: minutes)
                    let seconds = seconds.getStringFrom(seconds: seconds)
                    self.durationLabel.text = "\(hours):\(minutes):\(seconds)"
                    self.durationLabelBottom.text = "\(hours):\(minutes):\(seconds)"
                }
            }
        }
        
    }
    
    func initSpeechAuth() -> Void {
        
        SFSpeechRecognizer.requestAuthorization { [self] (authStatus) in
            var msg = ""
            
            switch authStatus {
            case .notDetermined:
                msg = "Speech Recognition Auth Not Determined"
                
            case .denied:
                msg = "Speech Recognition Auth Permission Denied"
                self.speechIsAuth = false
                
            case .restricted:
                msg = "Speech Recognition Auth Restricted"
                self.speechIsAuth = false

            case .authorized:
                msg = "Speech Recognition Auth Authorized"
                self.speechIsAuth = true
                
            @unknown default:
                fatalError()
            }
            print(msg)
            
            if let speechIsAuth = self.speechIsAuth {
                if speechIsAuth {
                    DispatchQueue.main.async {
                        self.initDuration()
                        self.audioRecorder!.isMeteringEnabled = true
                    }
                }
                else if !speechIsAuth {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: {
                            UIApplication.getTopMostViewController()?.present(
                                self.settingsAlert(title: "Speech Recognition Not Authorized", message: "Please give permission to speech recognition in settings for live transcription ability"),
                                animated: true, completion: nil
                            )
                        })
                    }
                }
            }
            
            
            
        }
    }
    
    func initRecordingSession() -> Void {
        recordingSession = AVAudioSession.sharedInstance()
        
        recordingSession?.requestRecordPermission({ _ in
            switch self.recordingSession!.recordPermission {
            case .granted:
                print("Recording Permission granted")
                self.micIsAuth = true
                
            case .denied:
                print("Recording Permission denied")
                self.micIsAuth = false
                
            case .undetermined:
                print("Recording Request permission here")
                
            @unknown default:
                print("Unknown case")
            }
            
            if let micIsAuth = self.micIsAuth {
                if micIsAuth {
                    do{
                        try self.recordingSession?.setCategory(.playAndRecord, mode: .default)
                        try self.recordingSession?.setActive(true)
                        self.recordingSession?.requestRecordPermission({ [unowned self] allowed in
                            
                            DispatchQueue.main.async {
                                if allowed {
                                    print("Recording instance ok")
                                } else {
                                    print("Recording instance failed")
                                }
                            }
                            
                        })
                    } catch {
                        print("Recording Session Error")
                        print(error.localizedDescription)
                    }
                    
                    self.setupNotifications()
                }
                else if !micIsAuth {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: {
                            UIApplication.getTopMostViewController()?.present(
                                self.settingsAlert(title: "Microphone Not Authorized", message: "Please give permission to microphone in settings to enable audio recording"),
                                animated: true, completion: nil
                            )
                        })
                    }
                }
            }
            
        })
        
    }
    
    func startRecording() -> Void {
        filename = getFileUrl()
        
        pencil.removeAllPoints()
        waveLayer.removeFromSuperlayer()
        writeWaves(0, false, 0)
        
        do {
            audioRecorder = try AVAudioRecorder(
                url: filename!,
                settings: [
                    AVFormatIDKey: kAudioFormatAppleLossless,
                    AVSampleRateKey: 44100.0,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
                ]
            )
            audioRecorder?.record()
            audioRecorder?.isMeteringEnabled = true
            
        } catch {
            if isWaveformVisible {
                waveformTimer.invalidate()
            }
            audioRecorder!.isMeteringEnabled = false
            stopRecording()
        }
        
        startWave()
    }
    
    func continueRecording() -> Void {
        audioRecorder?.isMeteringEnabled = true
        if isWaveformVisible {
            startWave()
        }
        audioRecorder?.record()
    }
    
    func pauseRecording() -> Void {
        audioRecorder!.isMeteringEnabled = false
        audioRecorder?.pause()
        if isWaveformVisible {
            waveformTimer.invalidate()
        }
    }
    
    func stopRecording() -> Void {
        audioRecorder!.isMeteringEnabled = false
        audioRecorder?.stop()
        audioRecorder = nil
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            audioRecorder!.isMeteringEnabled = false
            stopRecording()
        }
    }
    
    func getFileUrl() -> URL {
        let date = Date()
        filenameToSave = "\(date.generateTimestampForFilename()).m4a"
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filenameToSave)
    }
    
    func startTranscription() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(
                AVAudioSession.Category.record,
                mode: AVAudioSession.Mode.default,
                options: AVAudioSession.CategoryOptions.defaultToSpeaker
            )
            
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Speech Request Error")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        self.recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            var isFinal = false
            
            if result != nil {
                
                isFinal = (result?.isFinal)!
                
                self.transcriptionTemp2 = (result?.bestTranscription.formattedString)!
                
                var concat = ""
                
                if self.isPlaying{
                    let range = NSMakeRange(self.transcriptionResultTextView.text.count - 1, 0)
                    self.transcriptionResultTextView.scrollRangeToVisible(range)
                    
                    if self.transcriptionTemp == "" {
                        concat = "\(self.transcriptionTemp)\(self.transcriptionTemp2)"
                    } else {
                        concat = "\(self.transcriptionTemp)\n\n\(self.transcriptionTemp2)"
                    }
                    
                    self.transcriptionResultTextView.text = concat
                    print(concat)
                    
                    self.sendMessage([MessageKeyLoad.result: concat])
                }
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
            
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        self.audioEngine.prepare()
        
        do {
            try self.audioEngine.start()
        } catch {
            print("Audio Engine start error \n \(error.localizedDescription)")
        }
        
    }
    
    func transcribeOnLoad() -> Void {
        
        // State is playing, command to stop
        if audioEngine.isRunning {
            
            self.transcribeActionButton.isEnabled = false
            
            let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
                self.transcribeActionButton.isEnabled = true
            })
            
            if transcriptionTemp == "" {
                transcriptionTemp += "\(transcriptionTemp2)"
            } else {
                transcriptionTemp += "\n\n\(transcriptionTemp2)"
            }
            transcriptionResultTextView.text = transcriptionTemp
            transcriptionTemp2 = ""
            
            audioEngine.stop()
            recognitionRequest?.endAudio()
            pauseRecording()
            
            
            transcribeActionButton.setTitle("", for: .normal)
            transcribeActionButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            saveButton.isEnabled = true
            isPlaying = false
            sendIsPausing([MessageKeyLoad.isPausing: true])
            
//            audioEngine.inputNode.removeTap(onBus: 0)
        }
        
        // State is stopped, command to start
        else {
            
            self.transcribeActionButton.isEnabled = false
            
            let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
                self.transcribeActionButton.isEnabled = true
            })
            
            let locale = UserDefaults.standard.string(forKey: Constants.SELECTED_LANGUAGE)
            speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: locale!))
            startTranscription()
            continueRecording()
            
            transcribeActionButton.setTitle("", for: .normal)
            transcribeActionButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            saveButton.isEnabled = false
            isPlaying = true
            sendIsPlaying([MessageKeyLoad.isPlaying: true])
            
//            let timer = Timer.inte
            
        }
        let fourthBg = UIColor(named: "fourthBg")
        
        self.titleTextField.backgroundColor = fourthBg
        
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance())
    }
    
    func removeInterruptionObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue),
              let reason = AVAudioSession.InterruptionReason(rawValue: typeValue) else {
            return
        }
        
        switch type {
        case .began:
            switch reason {
            case .appWasSuspended:
                if isPlaying == true {
                    transcriptionTemp = transcriptionResultTextView.text
                    globalSave()
                }
            default: ()
            }
        default: ()
        }
    }
    
    func stateDidChange(newState: Int) {
        
        switch newState {
            
        case 1: // full modal
            navbar.isHidden = false
            titleToSuperview.constant = 60
            durationLabel.isHidden = true
            textViewToTitleConstraint.constant = 20
            durationLabelBottom.isHidden = false
            titleTextField.isHidden = false
            durationToSuperView.constant = 100
            
            if isWaveformVisible {
                if !waveformTimer.isValid {
                    audioRecorder?.isMeteringEnabled = true
                    startWave()
                }
            } else {
                audioRecorder!.isMeteringEnabled = false
                waveformTimer.invalidate()
            }
            
        case 2: // half modal
            
            navbar.isHidden = true
            titleToSuperview.constant = 20
            durationLabel.isHidden = false
            textViewToTitleConstraint.constant = 40
            durationLabelBottom.isHidden = true
            titleTextField.isHidden = true
            durationToSuperView.constant = 20
            
            audioRecorder!.isMeteringEnabled = false
            waveformTimer.invalidate()
            
        default:
            print("default")
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        let alert = UIAlertController(title: "Cancel Transcription?", message: "Are you sure to cancel the current transcription session?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(
            title: "Yes, Cancel",
            style: .destructive,
            handler: { _ in
                self.sendCanceling([MessageKeyLoad.canceling: true])
                self.audioEngine.stop()
                self.dismiss(animated: true)
                self.removeInterruptionObserver()
            }
        ))
        
        alert.addAction(UIAlertAction(
            title: "Stay Transcribing",
            style: .cancel,
            handler: nil
        ))
        
        present(alert, animated: true)
    }
    
    func globalCancel() {
        audioEngine.stop()
        dismiss(animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        sendSaving([MessageKeyLoad.saving: true])
        globalSave()
    }
    
    func globalSave() {
        audioRecorder!.isMeteringEnabled = false
        
        audioEngine.stop()
        stopRecording()
        
        print(filename!)

        let strTitle = titleTextField.text == "" ? "Untitled Transcription" : titleTextField.text
        
        let audioAsset = AVURLAsset.init(url: filename!)
        let duration = Int(CMTimeGetSeconds(audioAsset.duration))
        
        durationTemp.hmsFrom(seconds: durationTemp) { hours, minutes, seconds in
            let hours = seconds.getStringFrom(seconds: hours)
            let minutes = seconds.getStringFrom(seconds: minutes)
            let seconds = seconds.getStringFrom(seconds: seconds)
            self.durationString = "\(hours):\(minutes):\(seconds)"
        }
        
        TranscriptionRepository.shared.add(
            title: strTitle!,
            result: transcriptionTemp,
            duration: durationString,
            filename: filenameToSave
        )
        
        removeInterruptionObserver()
        print("\(filenameToSave)")
        delegate?.reloadTableView()
        dismiss(animated: true)
    }
    
    
    @IBAction func transcriptionActionButton(_ sender: Any) {
        transcribeOnLoad()
    }
    
    
    @IBAction func titleExit(_ sender: Any) {
        
    }
    
//    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
//        if available {
//            print("/n/n IS AVAILABLE /n/n")
//            transcribeActionButton.isEnabled = true
//        } else {
//            print("/n/n NOT AVAILABLE /n/n")
//            transcribeActionButton.isEnabled = false
//        }
//    }
    
    func makeItInvalidate(wvtimer: Bool, wvviewtimer: Bool) {
        if wvtimer {
            if waveTimer != nil {
                waveTimer.invalidate()
            }
            waveTimer = nil
        }
        if wvviewtimer {
            waveView.timer.invalidate()
        }
    }
    
    @objc func appMovedToBackground() {
        if isWaveformVisible {
            audioRecorder!.isMeteringEnabled = false
            waveformTimer.invalidate()
        }
    }
    
    @objc func appBecomeActive() {
        if isWaveformVisible {
            audioRecorder!.isMeteringEnabled = true
        }
    }
    
}



