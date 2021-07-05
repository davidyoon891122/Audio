//
//  ViewController.swift
//  Audio
//
//  Created by David Yoon on 2021/07/05.
//

import UIKit
// 오디오 재생을 위한 헤더
import AVFoundation
// 오디오 재생을 위한 델리게이트
class ViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet var pvProgressPlay: UIProgressView!
    @IBOutlet var lblCurrentTime: UILabel!
    
    @IBOutlet var lblEndTime: UILabel!
    
    @IBOutlet var btnPlay: UIButton!
    
    @IBOutlet var btnPause: UIButton!
    
    @IBOutlet var btnStop: UIButton!
    
    @IBOutlet var slVolume: UISlider!
    
    var audioPlayer: AVAudioPlayer!
    var audioFile: URL!
    let MAX_VOLUME: Float = 10.0
    var progressTimer: Timer!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnPlayAudio(_ sender: UIButton) {
    }
    
    @IBAction func btnPauseAudio(_ sender: UIButton) {
    }
    
    
    
    @IBAction func btnStopAudio(_ sender: UIButton) {
    }
    
    
    @IBAction func slChangeVolume(_ sender: UISlider) {
    }
}

