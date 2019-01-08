//
//  AudioViewController.swift
//  The Message App
//
//  Created by Vibol's Macbook Pro on 1/8/19.
//  Copyright © 2019 Vibol Roeun. All rights reserved.
//

import Foundation
import IQAudioRecorderController

class AudioViewController {
    
    var delegate: IQAudioRecorderViewControllerDelegate
    
    init(delegte_: IQAudioRecorderViewControllerDelegate) {
        delegate = delegte_
    }
    
    
    func presentAudioRecorder(target: UIViewController) {
        let controller = IQAudioRecorderViewController()
        controller.delegate = delegate
        controller.title = "Record"
        controller.maximumRecordDuration = kAUDIOMAXDURATION
        controller.allowCropping = true
        
        target.presentBlurredAudioRecorderViewControllerAnimated(controller)
    }
    
    
}


