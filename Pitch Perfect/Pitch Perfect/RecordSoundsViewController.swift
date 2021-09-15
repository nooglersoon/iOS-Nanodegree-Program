//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Fauzi Achmad B D on 11/08/21.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController,AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var tapToRecordLabel: UILabel!
    @IBOutlet weak var stopRecordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        configureUI(isRecording: false)
        
    }
    
    @IBAction func recordTapped(_ sender: AnyObject) {
        
        configureUI(isRecording: true)
        
        // Set the directory path
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) [0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath,recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        // Set audio session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        // Prepare and run record
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        
        
    }
    
    @IBAction func stopRecordTapped(_ sender: Any) {
        
        configureUI(isRecording: false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {

        
        if flag {
            
            // MARK: Call the segue after record finished recoding and successfullly recorded
            
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
            
            
        } else {
            
            print("There are some problem with recording session")
            
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "stopRecording" {
            
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudio = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudio
            
        }
        
    }
    
    func configureUI(isRecording: Bool){
        
        if isRecording {
            
            recordButton.isEnabled = false
            stopRecordButton.isEnabled = true
            tapToRecordLabel.text = "Recording in Progress"
            
        } else {
            
            recordButton.isEnabled = true
            stopRecordButton.isEnabled = false
            tapToRecordLabel.text = "Tap to Start Record"
            
        }
        
        
    }
    
    
}

