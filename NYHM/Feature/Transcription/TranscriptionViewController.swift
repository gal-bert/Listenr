//
//  TranscriptionViewController.swift
//  NYHM
//
//  Created by Hafizh Mo on 12/06/22.
//

import UIKit
import Speech
import AVKit

class TranscriptionViewController: UIViewController, SFSpeechRecognizerDelegate, AVAudioRecorderDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var transcriptionResultTextView: UITextView!
    @IBOutlet weak var transcribeActionButton: UIButton!
    
    var transcriptionTemp = ""
    
    let audioEngine = AVAudioEngine()
    
    var speechRecognizer: SFSpeechRecognizer?
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    
    var recordingSession: AVAudioSession?
    var audioRecorder: AVAudioRecorder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        speechRecognizer?.delegate = self
        audioRecorder?.delegate = self
        
        transcriptionResultTextView.text = ""
        
        initSpeechAuth()
        initRecordingSession()
        
        transcribeOnLoad()
        
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
        let filename = getFileUrl()
        
        do {
            audioRecorder = try AVAudioRecorder(
                url: filename,
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
        // TODO: Generate filename
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("recording.m4a")
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
                //TODO: Add textlabel for appending

                self.transcriptionResultTextView.text = (result?.bestTranscription.formattedString)!
                
                
                isFinal = (result?.isFinal)!
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
            
            
            
            audioEngine.stop()
            recognitionRequest?.endAudio()
//            stopRecording() // TODO: Change to pause recording
            transcribeActionButton.setTitle("Start", for: .normal)
            print("\n\n \(transcriptionResultTextView.text!)")
        }
        
        // State is stopped, command to start
        else {
            speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
            startTranscription()
//            startRecording()
            transcribeActionButton.setTitle("Stop", for: .normal)
            
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        
    }
    
    @IBAction func save(_ sender: Any) {
        
    }
    
    @IBAction func transcriptionActionButton(_ sender: Any) {
        transcribeOnLoad()
    }
    
}
