//
//  DriverOnboarding360State.swift
//  Driver Onboarding 360
//
//  Created by Robert Cash on 8/3/17.
//  Copyright © 2017 Robert Cash. All rights reserved.
//

import Foundation
import UIKit

struct DriverOnboarding360State {
    let videoFileName: String!
    let screenshots: [UIImage]!
    let headerText: String!
    let subheaderText: String!
    let textTriggerTime: Double! // In seconds left in video
    
    init(_ videoFileName: String, _ screenshots: [UIImage], _ headerText: String, _ subheaderText: String, _ textTriggerTime: Double) {
        self.videoFileName = videoFileName
        self.screenshots = screenshots
        self.headerText = headerText
        self.subheaderText = subheaderText
        self.textTriggerTime = textTriggerTime
    }
}
