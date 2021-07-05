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
        audioFile = Bundle.main.url(forResource: "Sicilian_Breeze", withExtension: "mp3")
        initPlay()
    }
    
    // 오디오 재생을 위한 함수
    func initPlay() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFile)
        } catch let error as NSError {
            print("Error-initPlay: \(error)")
        }
        
        slVolume.maximumValue = MAX_VOLUME // volume slider 맥스값 설정
        slVolume.value = 1.0 // 볼륨 슬라이더 현재값 설정
        pvProgressPlay.progress = 0 // 프로그래스뷰 0으로 초기화
        
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay() // 뭔지 모름
        audioPlayer.volume = slVolume.value // 오디오 볼륨 슬라이더 값으로 1 설정
        
        lblEndTime.text = convertNSTimeInterval2String(audioPlayer.duration) //audio 파일의 총 길이 값 리턴
        lblCurrentTime.text = convertNSTimeInterval2String(0)
        
        
        
        
    }
    // TimeInterval 값을 받아 문자열로 전환해 주는 함수
    func convertNSTimeInterval2String(_ time: TimeInterval) -> String {
        let min = Int(time/60) // 재생시간 매개변수인 time값을 60으로 나눈 '몫'
        let sec = Int(time.truncatingRemainder(dividingBy: 60)) // time을 60으로 나누고 남은 나머지 값을 sec에 할당
        let strTime = String(format: "%02d:%02d", min, sec)
        return strTime
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

