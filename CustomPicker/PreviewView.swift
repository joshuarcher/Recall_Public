//
//  PreviewView.swift
//  RecallPhotoTaker2
//
//  Created by Joshua Archer on 1/14/16.
//  Copyright © 2016 Joshua Archer. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class CameraPreviewView: UIView {
    
    var captureSession: AVCaptureSession? {
        get{
            return (self.layer as! AVCaptureVideoPreviewLayer).session
        }
        set(session){
            (self.layer as! AVCaptureVideoPreviewLayer).session = session
        }
    }
    
    override class func layerClass() -> AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
}
                                                                                                                          