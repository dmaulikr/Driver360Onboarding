//
//  DriverOnboarding360ViewController.swift
//  Driver Onboarding 360
//
//  Created by Robert Cash on 8/3/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

import UIKit
import AVFoundation

class DriverOnboarding360ViewController: UIViewController, DriverOnboarding360ViewControllerDelegate {
    
    let onboardingStates = [
        DriverOnboarding360State("online", [#imageLiteral(resourceName: "online")], "Let's go online!", "When you're ready to start making money, tap “Go Online”!", 60.0),
        DriverOnboarding360State("new_accept", [#imageLiteral(resourceName: "accept"), #imageLiteral(resourceName: "nav_to_pax"), #imageLiteral(resourceName: "google_to_pax")], "You got a ride!", "You have 60 seconds to accept the ride!", 50.0),
        DriverOnboarding360State("arrive", [#imageLiteral(resourceName: "arrive"), #imageLiteral(resourceName: "confirm_arrive")], "Drive to your passenger!", "Tap “Tap to arrive” and “Confirm arrival” when you’ve reached the address!", 50.0),
        DriverOnboarding360State("pickup", [#imageLiteral(resourceName: "pick_up"), #imageLiteral(resourceName: "google_to_dest")], "Are you John?", "Pick up your passenger and confirm their identity!", 50.0),
        DriverOnboarding360State("dropoff_edited", [#imageLiteral(resourceName: "drop_off"), #imageLiteral(resourceName: "confirm_drop_off"), #imageLiteral(resourceName: "rate_1"), #imageLiteral(resourceName: "rate_2")], "It's go time!", "Drive the passenger to their destination!", 100.0)
    ]
    
    var currentState: DriverOnboarding360State?
    var currentStateNumber: Int = 0
    
    var video360View: Video360View!
    var screenshotView: ScreenshotView!
    var audioPlayer: AVAudioPlayer!
    var timeTimer: Timer!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var subheaderView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subheaderLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.currentStateNumber = 0
        self.currentState = self.onboardingStates[self.currentStateNumber]
        
        self.setUpAudio()
        self.setUpVideoView()
        self.setUpText()
        self.setUpScreenshotView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpVideoView() {
        self.video360View = Video360View(frame: self.view.frame, videoFileName: (self.currentState?.videoFileName)!)
        self.view.addSubview(self.video360View)
        self.video360View.videoPlayer.isMuted = true
        self.video360View.play(self)
        self.setUpTimer()
        self.playVideo()
    }
    
    func setUpTimer() {
        self.timeTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkPlayback), userInfo: nil, repeats: true)
    }
    
    func setUpText() {
        self.headerView.blur()
        self.subheaderView.blur()
        self.headerLabel.text = self.currentState?.headerText
        self.subheaderLabel.text = self.currentState?.subheaderText
        self.headerView.alpha = 0.0
        self.subheaderView.alpha = 0.0
        
        self.view.addSubview(self.headerView)
        self.view.addSubview(self.subheaderView)
        self.headerView.addSubview(self.headerLabel)
        self.subheaderView.addSubview(self.subheaderLabel)
    }

    func setUpScreenshotView() {
        self.screenshotView = ScreenshotView(frame: self.view.frame)
        self.screenshotView.controllerDelegate = self
        self.screenshotView.setScreenshots(images: (self.currentState?.screenshots)!)
        self.view.addSubview(screenshotView)
    }
    
    func setUpAudio() {
        do {
            let fileName = URL(fileURLWithPath: Bundle.main.path(forResource: "lyft_music", ofType:"mp3")!)
            try self.audioPlayer = AVAudioPlayer(contentsOf: fileName)
        }
        catch {
            
        }
    }
    
    func videoEnded() {
        self.screenshotView.setScreenshots(images: (self.currentState?.screenshots)!)
        self.screenshotView.fadeIn()
        
        if self.currentStateNumber < self.onboardingStates.count - 1 {
            self.nextVideoSetup()
        }
        else {
            self.currentStateNumber = -1
            self.nextVideoSetup()
        }
    }
    
    func checkPlayback() {
        if CMTimeGetSeconds(self.video360View.currentItem.duration) - CMTimeGetSeconds(self.video360View.videoPlayer.currentTime()) < (self.currentState?.textTriggerTime)! {
            self.triggerText()
        }
    }
    
    func triggerText() {
        self.timeTimer.invalidate()
        self.headerView.mistIn()
        self.subheaderView.mistIn()
    }
    
    func hideText() {
        self.headerView.mistOut()
        self.subheaderView.mistOut()
        
        self.headerLabel.text = self.currentState?.headerText
        self.subheaderLabel.text = self.currentState?.subheaderText
    }
    
    func nextVideoSetup() {
        print(self.currentStateNumber)
        self.currentStateNumber += 1
        self.currentState = self.onboardingStates[currentStateNumber]
        let fileName = self.currentState?.videoFileName!
        print(fileName!)
        let filePathUrl = URL(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType:"mp4")!)
        self.video360View.currentItem = AVPlayerItem(url: filePathUrl)
        self.video360View.videoPlayer.replaceCurrentItem(with: self.video360View.currentItem)
    }
    
    func playVideo() {
        NotificationCenter.default.addObserver(self,selector:#selector(self.videoEnded), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.video360View.currentItem)
        self.video360View.videoPlayer.play()
        self.setUpTimer()
        self.audioPlayer.play()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }  

}

protocol DriverOnboarding360ViewControllerDelegate: class {
    func playVideo()
    func hideText()
}
