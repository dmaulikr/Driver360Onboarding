//
//  UIViewExtensions.swift
//  Driver Onboarding 360
//
//  Created by Robert Cash on 8/4/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func blur() {
        let effectView = UIVisualEffectView()
        effectView.effect = UIBlurEffect(style: .dark)
        effectView.frame = self.frame
        self.addSubview(effectView)
    }
    
    func mistIn() {
        UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
    
    func mistOut() {
        UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
}
