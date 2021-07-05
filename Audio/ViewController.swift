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
class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    // for player
    @IBOutlet var pvProgressPlay: UIProgressView!
    @IBOutlet var lblCurrentTime: UILabel!
    @IBOutlet var lblEndTime: UILabel!
    @IBOutlet var btnPlay: UIButton!
    @IBOutlet var btnPause: UIButton!
    @IBOutlet var btnStop: UIButton!
    @IBOutlet var slVolume: UISlider!
    
    // for record
    @IBOutlet var btnRecod: UIButton!
    @IBOutlet var lblRecordTime: UILabel!
    
    // for player
    var audioPlayer: AVAudioPlayer!
    var audioFile: URL!
    let MAX_VOLUME: Float = 10.0
    var progressTimer: Timer!
    
    let timePlayerSelector: Selector = #selector(ViewController.updatePlayTime)
    
    // for record
    var audioRecorder: AVAudioRecorder!
    var isRecordMode = false
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        selectAudioFile()
        if !isRecordMode {
            initPlay()
            btnRecod.isEnabled = false
            lblRecordTime.isEnabled = false
        } else {
            initRecord()
        }
    }
    
    // record 모드 인지 아닌지에 따라 재성되는 파일 설정 다르게
    func selectAudioFile() {
        if !isRecordMode {
            audioFile = Bundle.main.url(forResource: "Sicilian_Breeze", withExtension: "mp3")
        } else { //녹음 모드일때 처리
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            audioFile = documentDirectory.appendingPathComponent("recordFile.m4a")
        }
        
    }
    
    // 녹음을 위한 초기화 함수
    func initRecord() {
        let recordSettings = [
            AVFormatIDKey : NSNumber(value: kAudioFormatAppleLossless as UInt32),
            AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey : 320000,
            AVNumberOfChannelsKey : 2,
            AVSampleRateKey : 44100.0] as [String : Any]
        do {
            audioRecorder = try AVAudioRecorder(url: audioFile, settings: recordSettings) // audioRecorder 를 생성하기 위해 audioFile과 [String:Any] 타입 record 세팅 넣어줌
        } catch let error as NSError {
            print("Error-initRecord : \(error)")
        }
        
        audioRecorder.delegate = self //audioRecorder의 델리게이트 선언 델리게이트 알아봐야함
        
        slVolume.value = 1.0 // 볼륨 초기화
        audioPlayer.volume = slVolume.value
        lblEndTime.text = convertNSTimeInterval2String(0) // 타임 초기화
        lblCurrentTime.text = convertNSTimeInterval2String(0)
        setPlayButtons(false, pause: false, stop: false) // 플레이 버튼 비활성화
        
        let session = AVAudioSession.sharedInstance()
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print(" Error-setCategory: \(error)")
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print(" Error-setActivate : \(error)")
        }
        
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
        
        
        // setPlayButtons로 대체
        // 버튼 제어
//        btnPlay.isEnabled = true // 초기화 후 플레이버튼 활성화
//        btnPause.isEnabled = false // 재생 전이니 비활성화
//        btnStop.isEnabled = false // 재생 전 비활성화
        setPlayButtons(true, pause: false, stop: false)
        
        
        
    }
    
    @objc func updatePlayTime() {
        lblCurrentTime.text = convertNSTimeInterval2String(audioPlayer.currentTime)
        pvProgressPlay.progress = Float(audioPlayer.currentTime/audioPlayer.duration)
    }
    
    
    
    // TimeInterval 값을 받아 문자열로 전환해 주는 함수
    func convertNSTimeInterval2String(_ time: TimeInterval) -> String {
        let min = Int(time/60) // 재생시간 매개변수인 time값을 60으로 나눈 '몫'
        let sec = Int(time.truncatingRemainder(dividingBy: 60)) // time을 60으로 나누고 남은 나머지 값을 sec에 할당
        let strTime = String(format: "%02d:%02d", min, sec)
        return strTime
    }
    
    // 버튼 제어 함수
    func setPlayButtons(_ play: Bool, pause: Bool, stop: Bool) {
        btnPlay.isEnabled = play
        btnPause.isEnabled = pause
        btnStop.isEnabled = stop
    }
    

    @IBAction func btnPlayAudio(_ sender: UIButton) {
        audioPlayer.play()
        setPlayButtons(false, pause: true, stop: true)
        progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timePlayerSelector, userInfo: nil, repeats: true)
        
    }
    
    @IBAction func btnPauseAudio(_ sender: UIButton) {
        audioPlayer.pause()
        setPlayButtons(true, pause: false, stop: false)
        
    }
    
    
    
    @IBAction func btnStopAudio(_ sender: UIButton) {
        audioPlayer.stop()
        setPlayButtons(true, pause: false, stop: false)
        audioPlayer.currentTime = 0
        lblCurrentTime.text = convertNSTimeInterval2String(0)
        progressTimer.invalidate() // 타이머 무효화
    }
    
    
    @IBAction func slChangeVolume(_ sender: UISlider) {
        audioPlayer.volume = slVolume.value
    }
    
    
    // 오디오 재생이 끝나면 맨 처음 상태로 되돌리는 함수
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        progressTimer.invalidate()
        setPlayButtons(true, pause: false, stop: false)
    }
    
    
    
    @IBAction func swRecordMode(_ sender: UISwitch) {
        if sender.isOn {
            audioPlayer.stop()
            audioPlayer.currentTime = 0
            lblRecordTime!.text = convertNSTimeInterval2String(0)
            isRecordMode = true
            btnRecod.isEnabled = true
            lblRecordTime.isEnabled = true
        } else {
            isRecordMode = false
            btnRecod.isEnabled = false
            lblRecordTime.isEnabled = false
            lblRecordTime.text = convertNSTimeInterval2String(0)
        }
        selectAudioFile()
        if !isRecordMode {
            initPlay()
        } else {
            initRecord()
        }
    }
    
    @IBAction func btnRecord(_ sender: UIButton) {
        if (sender as AnyObject).titleLabel?.text == "Record" {
            audioRecorder.record()
            (sender as AnyObject).setTitle("Stop", for: UIControl.State())
        } else {
            audioRecorder.stop()
            (sender as AnyObject).setTitle("Record", for: UIControl.State())
            btnPlay.isEnabled = true
            initPlay()
        }
    }
    
}

