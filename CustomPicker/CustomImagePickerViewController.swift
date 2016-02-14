//
//  CustomImagePickerViewController.swift
//  RecallPhotoTaker2
//
//  Created by Joshua Archer on 1/13/16.
//  Copyright © 2016 Joshua Archer. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

var SessionRunningAndDeviceAuthorizedContext = "SessionRunningAndDeviceAuthorizedContext"
var CapturingStillImageContext = "CapturingStillImageContext"
var RecordingContext = "RecordingContext"

class CustomImagePickerViewController: UIViewController {
    
    // MARK: - AVCapture Session Variables
    weak var capturedImage: UIImage?
    
    var sessionQueue: dispatch_queue_t!
    var session: AVCaptureSession?
    var videoDeviceInput: AVCaptureDeviceInput?
    var stillImageOutput: AVCaptureStillImageOutput?
    
    var capturePosition: AVCaptureDevicePosition = .Back
    
    var deviceAuthorized: Bool = false
    var backgroundRecordId: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    var sessionRunningDeviceAuthorized: Bool {
        get {
            return (self.session?.running != nil && deviceAuthorized)
        }
    }
    
    var runtimeErrorHandlingObserver: AnyObject?
    var flashActive: Bool? = false
    
    
    // MARK: - CollectionView Variables
    
    private let cellNibName = "CustomImagePickerCollectionViewCell"
    private let cellReuseId = "customPickerCell"
    
    @IBOutlet weak var previewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var previewView: CameraPreviewView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let screenWidthOThree = UIScreen.mainScreen().bounds.size.width/3
    
    let imageManager = PHImageManager.defaultManager()
    let cachingManger = PHCachingImageManager()
    var photoAssets: [PHAsset] = [] {
        willSet {
            cachingManger.stopCachingImagesForAllAssets()
        }
        didSet {
            // let width = self.collectionView.frame.width/3
            let size: CGSize = CGSizeMake(screenWidthOThree, screenWidthOThree)
            cachingManger.startCachingImagesForAssets(self.photoAssets, targetSize: size, contentMode: .AspectFill, options: nil)
            collectionView.reloadData()
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCellForCollection()
        initialImageRequest()
        collectionView.backgroundView = nil
        collectionView.backgroundColor = UIColor.clearColor()
        setUpSession()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        runSession()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        stopSession()
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        //self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    
    func initialImageRequest() {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult = PHAsset.fetchAssetsWithMediaType(.Image, options: fetchOptions)
        var length = 50
        if fetchResult.count < length {
            length = fetchResult.count
        }
        
        if let assets = fetchResult.objectsAtIndexes(NSIndexSet(indexesInRange: NSRange(location: 0, length: length))) as? [PHAsset] {
            self.photoAssets = assets
        }
    }
    
    private func registerCellForCollection() {
        let nib = UINib(nibName: cellNibName, bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: cellReuseId)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func cameraButtonTapped(sender: AnyObject) {
        captureStillImage()
    }
    
    @IBAction func cameraFlipTapped(sender: AnyObject) {
        stopSession()
        if capturePosition == .Front {
            capturePosition = .Back
        } else if capturePosition == .Back {
            capturePosition = .Front
        }
        setUpSession()
        runSession()
    }
    
    @IBAction func exitButtonTapped(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}

extension CustomImagePickerViewController {
    
    // MARK: - Session cycle
    
    func setUpSession() {
        let session: AVCaptureSession = AVCaptureSession()
        self.session = session
        self.previewView.captureSession = session
        
        self.checkDeviceAuthorizationStatus()
        
        let sessionQueue: dispatch_queue_t = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL)
        self.sessionQueue = sessionQueue
        
        dispatch_async(sessionQueue, {
            self.backgroundRecordId = UIBackgroundTaskInvalid
            
            let videoDevice: AVCaptureDevice! = CustomImagePickerViewController.deviceWithMediaType(AVMediaTypeVideo, prefferingPosition: self.capturePosition)
            var error: NSError? = nil
            
            // create device input
            var videoDeviceInput: AVCaptureDeviceInput?
            do {
                videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            } catch let error1 as NSError {
                error = error1
                videoDeviceInput = nil
            } catch {
                fatalError()
            }
            
            if error != nil {
                print(error)
                let alert = UIAlertController(title: "Error", message: error!.localizedDescription
                    , preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            // add input to the capture session and display in camera preview layer
            
            if session.canAddInput(videoDeviceInput) {
                session.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
                
                // UIView to display can only be manipulated on main thread, so get main thread
                dispatch_async(dispatch_get_main_queue(), {
                    
                    let orientation = AVCaptureVideoOrientation.Portrait
                    
                    if let layer = self.previewView.layer as? AVCaptureVideoPreviewLayer {
                        layer.connection.videoOrientation = orientation
                        layer.videoGravity = AVLayerVideoGravityResizeAspectFill
                    }
                    // (self.previewView.layer as! AVCaptureVideoPreviewLayer).connection.videoOrientation = orientation
                    
                })
                
            }
            
            // create still image output
            let stillImageOutput: AVCaptureStillImageOutput = AVCaptureStillImageOutput()
            if session.canAddOutput(stillImageOutput) {
                stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
                session.addOutput(stillImageOutput)
                
                self.stillImageOutput = stillImageOutput
            }
            
        })
        
    }
    
    func runSession() {
        
        dispatch_async(self.sessionQueue, {
            
            self.addObserver(self, forKeyPath: "sessionRunningAndDeviceAuthorized", options: [.Old , .New] , context: &SessionRunningAndDeviceAuthorizedContext)
            self.addObserver(self, forKeyPath: "stillImageOutput.capturingStillImage", options:[.Old , .New], context: &CapturingStillImageContext)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "subjectAreaDidChange:", name: AVCaptureDeviceSubjectAreaDidChangeNotification, object: self.videoDeviceInput?.device)
            
            
            weak var weakSelf = self
            
            self.runtimeErrorHandlingObserver = NSNotificationCenter.defaultCenter().addObserverForName(AVCaptureSessionRuntimeErrorNotification, object: self.session, queue: nil, usingBlock: { (note: NSNotification?) -> Void in
                let strongSelf: CustomImagePickerViewController = weakSelf!
                dispatch_async(strongSelf.sessionQueue, {
                    if let sesh = strongSelf.session {
                        sesh.startRunning()
                    }
                })
                
            })
            if let session = self.session {
                session.startRunning()
            }
        })
    }
    
    func stopSession() {
        dispatch_async(self.sessionQueue, {
            if let sesh = self.session {
                sesh.stopRunning()
                
                NSNotificationCenter.defaultCenter().removeObserver(self, name: AVCaptureDeviceSubjectAreaDidChangeNotification, object: self.videoDeviceInput?.device)
                NSNotificationCenter.defaultCenter().removeObserver(self.runtimeErrorHandlingObserver!)
                
                self.removeObserver(self, forKeyPath: "sessionRunningAndDeviceAuthorized", context: &SessionRunningAndDeviceAuthorizedContext)
                
                self.removeObserver(self, forKeyPath: "stillImageOutput.capturingStillImage", context: &CapturingStillImageContext)
                
            }
        })
    }
    
    // MARK: - Image capture
    
    func captureStillImage() {
        dispatch_async(self.sessionQueue, {
            guard let stillImageOutput = self.stillImageOutput, videoDeviceInput = self.videoDeviceInput else {return}
            // update orientation
            let videoOrientation =  (self.previewView.layer as! AVCaptureVideoPreviewLayer).connection.videoOrientation
            stillImageOutput.connectionWithMediaType(AVMediaTypeVideo).videoOrientation = videoOrientation
            
            // set autoflash
            var flashMode: AVCaptureFlashMode = .Auto
            if let flashActive = self.flashActive {
                if flashActive {
                    flashMode = .On
                } else {
                    flashMode = .Off
                }
            }
            CustomImagePickerViewController.setFlashMode(flashMode, device: videoDeviceInput.device)
            
            
            
            self.stillImageOutput?.captureStillImageAsynchronouslyFromConnection(stillImageOutput.connectionWithMediaType(AVMediaTypeVideo), completionHandler: { (imageDataSampleBuffer: CMSampleBuffer?, error: NSError?) -> Void in
                if let error = error {
                    NSLog("error capturing still image async with error: %@", error)
                } else {
                    if let buffer = imageDataSampleBuffer {
                        let data: NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
                        let image: UIImage = UIImage(data: data)!
                        self.capturedImage = image
                        self.showNextView()
                        
                    }
                }
            })
            
        })
    }
    
    class func setFlashMode(flashMode: AVCaptureFlashMode, device: AVCaptureDevice) {
        
        if device.hasFlash && device.isFlashModeSupported(flashMode) {
            var error: NSError? = nil
            do {
                try device.lockForConfiguration()
                device.flashMode = flashMode
                device.unlockForConfiguration()
            } catch let error1 as NSError {
                error = error1
                NSLog("Error setting flash mode %@", error!)
            }
        }
        
    }
    
    // MARK: - Helper methods
    
    func subjectAreaDidChange(notification: NSNotification){
        let devicePoint: CGPoint = CGPoint(x: 0.5, y: 0.5)
        self.focusWithMode(AVCaptureFocusMode.ContinuousAutoFocus, exposureMode: AVCaptureExposureMode.ContinuousAutoExposure, point: devicePoint, monitorSubjectAreaChange: false)
    }
    
    func focusWithMode(focusMode:AVCaptureFocusMode, exposureMode:AVCaptureExposureMode, point:CGPoint, monitorSubjectAreaChange:Bool){
        
        dispatch_async(self.sessionQueue, {
            let device: AVCaptureDevice! = self.videoDeviceInput!.device
            
            do {
                try device.lockForConfiguration()
                
                if device.focusPointOfInterestSupported && device.isFocusModeSupported(focusMode){
                    device.focusMode = focusMode
                    device.focusPointOfInterest = point
                }
                if device.exposurePointOfInterestSupported && device.isExposureModeSupported(exposureMode){
                    device.exposurePointOfInterest = point
                    device.exposureMode = exposureMode
                }
                device.subjectAreaChangeMonitoringEnabled = monitorSubjectAreaChange
                device.unlockForConfiguration()
                
            }catch{
                print(error)
            }
            
            
            
            
        })
        
    }
    
    func checkDeviceAuthorizationStatus() {
        let mediaType: String = AVMediaTypeVideo
        
        AVCaptureDevice.requestAccessForMediaType(mediaType) { (success: Bool) -> Void in
            if success {
                self.deviceAuthorized = true
            } else {
                // show alert on main queue
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let alert = UIAlertController(title: "CAM", message: "no access to camera", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Default, handler: { (action2: UIAlertAction) -> Void in
                        exit(0)
                    })
                    
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                })
                
                self.deviceAuthorized = false
            }
        }
    }
    
    class func deviceWithMediaType(mediaType: String, prefferingPosition: AVCaptureDevicePosition) -> AVCaptureDevice {
        
        var devices = AVCaptureDevice.devicesWithMediaType(mediaType)
        var captureDevice: AVCaptureDevice = devices[0] as! AVCaptureDevice
        
        for device in devices {
            if device.position == prefferingPosition {
                captureDevice = device as! AVCaptureDevice
                break
            }
        }
        
        return captureDevice
    }
    
    func showImage() {
        if let capturedImage = capturedImage {
            let newView = UIImageView(frame: self.view.frame)
            newView.image = capturedImage
            self.view.addSubview(newView)
            self.view.bringSubviewToFront(newView)
        }
    }
    
    func showNextView() {
        
        if let capturedImage = capturedImage {
            let nextVC = CapturedImageViewController()
            nextVC.imageTaken = capturedImage
            self.navigationController?.pushViewController(nextVC, animated: false)
            // presentViewController(nextVC, animated: true, completion: nil)
            //self.navigationController?.pushViewController(nextVC, animated: false)
        }
    }
    
    func showNextView(withImage image: UIImage) {
        let nextVC = CapturedImageViewController()
        nextVC.imageTaken = image
        self.navigationController?.pushViewController(nextVC, animated: true)
//        presentViewController(nextVC, animated: true, completion: nil)
    }
    
    // MARK: - Key value observing
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &CapturingStillImageContext{
            let isCapturingStillImage: Bool = change![NSKeyValueChangeNewKey]!.boolValue
            if isCapturingStillImage {
                print("is capturing")
            }
        }
        else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
}

extension CustomImagePickerViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let asset = photoAssets[indexPath.row]
        
        let options = PHImageRequestOptions()
        options.resizeMode = .Fast
        options.deliveryMode = .Opportunistic
        imageManager.requestImageForAsset(asset, targetSize: PHImageManagerMaximumSize, contentMode: .AspectFill, options: options) { (image: UIImage?, _) -> Void in
            if let image = image {
                self.showNextView(withImage: image)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAssets.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseId, forIndexPath: indexPath) as? CustomImagePickerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if cell.tag != 0 {
            imageManager.cancelImageRequest(PHImageRequestID(cell.tag))
        }
        
        let asset = photoAssets[indexPath.row]
        
        cell.tag = Int(imageManager.requestImageForAsset(asset,
            targetSize: CGSize(width: screenWidthOThree, height: screenWidthOThree),
            contentMode: .AspectFill,
            options: nil, resultHandler: { (image: UIImage?, _) -> Void in
                
                if let image = image {
                    cell.imageView.image = image
                }
        }))
        
        return cell
    }
    
    // Flow Layout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        let cellWidth = screenWidth/3
        
        let row = indexPath.row
        
        if row == 0 || row == 1 || row == 2 {
            let size: CGSize = CGSizeMake(cellWidth, cellWidth + 4)
            return size
        } else {
            let size: CGSize = CGSizeMake(cellWidth, cellWidth)
            return size
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        let spacing: CGFloat = 0
        return spacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let previewHeight = self.previewView.frame.height
        let insets = UIEdgeInsetsMake(previewHeight, 0, 0, 0)
        return insets
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        let spacing: CGFloat = 0
        return spacing
    }
    
}

extension CustomImagePickerViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.collectionView == scrollView {
            let yOffset = scrollView.contentOffset.y
            let previewHeightnWidth = self.previewView.frame.height
            
            if yOffset <= 0 {
                self.previewTopConstraint.constant = 0
            } else if yOffset < previewHeightnWidth {
                self.previewTopConstraint.constant = -yOffset
            } else if yOffset >= previewHeightnWidth {
                self.previewTopConstraint.constant = -previewHeightnWidth
            }
            
        }
    }
}
