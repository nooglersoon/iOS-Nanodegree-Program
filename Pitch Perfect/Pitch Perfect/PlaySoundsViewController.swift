//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Fauzi Achmad B D on 12/08/21.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var recordedAudioURL: URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
    }
    
    
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var highPitchButton: UIButton!
    @IBOutlet weak var lowPitchButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    // MARK: First Configuration about Audio Setup and UI
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureUI(.notPlaying)
        
        slowButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        fastButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        highPitchButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        lowPitchButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        echoButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        reverbButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        stopButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        
    }
    
    // MARK: Function that will executed when play button pressed
    
    @IBAction func playButtonPressed(_ sender: AnyObject){
        
        switch(ButtonType(rawValue: sender.tag)!) {
            case .slow:
                playSound(rate: 0.5)
            case .fast:
                playSound(rate: 1.5)
            case .chipmunk:
                playSound(pitch: 1000)
            case .vader:
                playSound(pitch: -1000)
            case .echo:
                playSound(echo: true)
            case .reverb:
                playSound(reverb: true)
            }

            configureUI(.playing)
        
        
    }
    
    
    // MARK: Function that will executed when stop button pressed
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        
        stopAudio()
        
    }
    
    
}
