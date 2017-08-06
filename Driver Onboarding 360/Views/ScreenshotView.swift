//
//  ScreenshotView.swift
//  Driver Onboarding 360
//
//  Created by Robert Cash on 8/3/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

import UIKit

class ScreenshotView: UIView {
    
    var images: [UIImage]?
    var slideNumber: Int?

    var imageView: UIImageView!
    var button: UIButton!
    
    weak var controllerDelegate: DriverOnboarding360ViewControllerDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Make invisible
        self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        
        // Setup image view
        self.imageView = UIImageView(frame: frame)
        self.imageView.contentMode = .scaleAspectFit
        
        self.addSubview(self.imageView)
        
        // Set up button
        self.button = UIButton(frame: frame)
        self.button.showsTouchWhenHighlighted = false
        self.button.addTarget(self, action: #selector(goToNextImage), for: .touchUpInside)
        self.button.isEnabled = false
        self.addSubview(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setScreenshots(images: [UIImage]) {
        self.images = images
        self.imageView.image = self.images![0]
        self.slideNumber = 0
    }
    
    func goToNextImage() {
        if slideNumber! < (self.images?.count)! - 1 {
            self.slideNumber! += 1
            self.imageView.image = self.images![slideNumber!]
        }
        else {
            self.controllerDelegate.playVideo()
            self.fadeOut()
            self.slideNumber = 0
        }
    }
    
    func fadeIn(duration: TimeInterval = 0.75, easingOffset: CGFloat = 0.4) {
        let easeScale = 1.0 + easingOffset
        let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
        let scalingDuration = duration - easingDuration
        UIView.animate(withDuration: scalingDuration, delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
            self.alpha = 1.0
            self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
        }, completion: { (completed: Bool) -> Void in
            UIView.animate(withDuration: easingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                self.transform = CGAffineTransform.identity
            }, completion: { (completed: Bool) -> Void in
                self.button.isEnabled = true
                self.controllerDelegate.hideText()
            })
        })
    }
    
    
    
    func fadeOut(duration: TimeInterval = 1.0, easingOffset: CGFloat = 0.7) {
        //let easeScale = 1.0 + easingOffset
        //let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
        //let scalingDuration = duration - easingDuration
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut , animations: { () -> Void in
            self.alpha = 0.0
        }, completion: { (completed: Bool) -> Void in
            self.button.isEnabled = false
            self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        })
        /*
        UIView.animate(withDuration: 0.5, delay: 0.0, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }, completion: { (completed: Bool) -> Void in
            UIView.animate(withDuration: scalingDuration, delay: 0.0, options: .curveEaseOut , animations: { () -> Void in
                self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            }, completion: { (completed: Bool) -> Void in
                self.button.isEnabled = false
            })
        })
 */
    }
 
}
