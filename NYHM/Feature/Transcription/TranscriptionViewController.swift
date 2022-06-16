//
//  TranscriptionViewController.swift
//  NYHM
//
//  Created by Hafizh Mo on 12/06/22.
//

import UIKit
import Speech
import AVKit

protocol SaveTranscriptionProtocol {
    func reloadTableView()
}

class TranscriptionViewController: UIViewController, SFSpeechRecognizerDelegate, AVAudioRecorderDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var transcriptionResultTextView: UITextView!
    @IBOutlet weak var transcribeActionButton: UIButton!
    
    var homeController = HomeViewController()
    
    var delegate:SaveTranscriptionProtocol?
    
    var transcriptionTemp = ""
    var transcriptionTemp2 = ""
    var filename:URL?
    var isPlaying:Bool = true
    
    var durationString:String = ""
    
    let audioEngine = AVAudioEngine()
    
    var speechRecognizer: SFSpeechRecognizer?
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    
    var recordingSession: AVAudioSession?
    var audioRecorder: AVAudioRecorder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transcriptionResultTextView.layer.borderColor = UIColor.black.cgColor
        transcriptionResultTextView.layer.borderWidth = 1
        
        speechRecognizer?.delegate = self
        audioRecorder?.delegate = self
        
        transcriptionResultTextView.text = ""
        
        initSpeechAuth()
        initRecordingSession()
        
        transcribeOnLoad()
        startRecording()
    }
    
    func initSpeechAuth() -> Void {
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            var msg = ""
            
            switch authStatus {
            case .notDetermined:
                msg = "Transcribe Ready"
            case .denied:
                msg = "Speech Recognition Permission Denied"
            case .restricted:
                msg = "Speech Recognition Restricted"
            case .authorized:
                msg = "Speech Recognition Restricted"
            @unknown default:
                fatalError()
            }
            
            print(msg)
        }
    }
    
    func initRecordingSession() -> Void {
        recordingSession = AVAudioSession.sharedInstance()
        do{
            try recordingSession?.setCategory(.playAndRecord, mode: .default)
            try recordingSession?.setActive(true)
            recordingSession?.requestRecordPermission({ [unowned self] allowed in
                
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
    }
    
    func startRecording() -> Void {
        filename = getFileUrl()
        
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
        } catch {
            stopRecording()
        }
        
    }
    
    func continueRecording() -> Void {
        audioRecorder?.record()
    }
    
    func pauseRecording() -> Void {
        audioRecorder?.pause()
    }
    
    func stopRecording() -> Void {
        audioRecorder?.stop()
        audioRecorder = nil
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            stopRecording()
        }
    }
    
    func getFileUrl() -> URL {
        let date = Date()
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(date.generateTimestampForFilename()).m4a")
    }
    
    func startTranscription() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
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
            
            transcribeActionButton.setTitle("Start", for: .normal)
            isPlaying = false
        }
        
        // State is stopped, command to start
        else {
            speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "id"))
            startTranscription()
            continueRecording()
            
            transcribeActionButton.setTitle("Stop", for: .normal)
            isPlaying = true
            
        }
    }
    
//    func hmsFrom(seconds: Int, completion: @escaping (_ hours: Int, _ minutes: Int, _ seconds: Int)->()) {
//        completion(seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
//    }
//    
//    func getStringFrom(seconds: Int) -> String {
//        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
//    }
    
    @IBAction func cancel(_ sender: Any) {
        audioEngine.stop()
        dismiss(animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        
        audioEngine.stop()
        stopRecording()
        
        print(filename!)
        
        // TODO: Save to CoreData
        /// Transcription Title (if nil -> "Untitled Transcription")
        /// Filename -> iHear_20220301_140439
        /// Transcription Result -> transcriptionTemp
        
        let strFilename = "\(filename!)"
        let strTitle = titleTextField.text == "" ? "Untitled Transcription" : titleTextField.text
        
        let audioAsset = AVURLAsset.init(url: filename!)
        let duration = Int(CMTimeGetSeconds(audioAsset.duration))
        
        var seconds: Int = duration
        seconds.hmsFrom(seconds: seconds) { hours, minutes, seconds in
            let hours = seconds.getStringFrom(seconds: hours)
            let minutes = seconds.getStringFrom(seconds: minutes)
            let seconds = seconds.getStringFrom(seconds: seconds)
            self.durationString = "\(hours):\(minutes):\(seconds)"
        }
        
        TranscriptionRepository.shared.add(
            title: strTitle!,
            result: transcriptionTemp,
            duration: durationString,
            filename: strFilename
        )
        
        delegate?.reloadTableView()
        dismiss(animated: true)
        
    }
    
    @IBAction func transcriptionActionButton(_ sender: Any) {
        transcribeOnLoad()
    }
    
}
