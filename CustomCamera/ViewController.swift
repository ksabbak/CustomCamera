//
//    This is me learning how to build a custom camera and practice.
//
//  ViewController.swift
//  CustomCamera
//
//  Created by k_sabbak on 6/7/16.
//  Copyright © 2016 k_sabbak. All rights reserved.
//
//  This was the tutorial I used to learn the base: http://drivecurrent.com/devops/using-swift-and-avfoundation-to-create-a-custom-camera-view-for-an-ios-app/
//  Alterations have been made from there, obvs.

import UIKit
import AVFoundation  //This makes the whole custom camera thing possible. Go figure.

class ViewController: UIViewController {

    
    //Note: When creating a custom camera from scratch and not just doing a camera overlay, you actually use the storyboard instead of a xib, go figure?
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var viewView: UIView!  //So this is actually the camera preview view and should have probably been called something better
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = AVCaptureSessionPresetPhoto
        
        //Apparently default tends to be the back camera?
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do
        {
            let input = try AVCaptureDeviceInput(device: backCamera)
            
            if captureSession!.canAddInput(input)
            {
                captureSession!.addInput(input)
                
                stillImageOutput = AVCaptureStillImageOutput()
                stillImageOutput?.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
                if captureSession!.canAddOutput(stillImageOutput)
                {
                    captureSession!.addOutput(stillImageOutput)
                    
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    viewView.layer.addSublayer(previewLayer!)
                    view.sendSubviewToBack(viewView)
                    
                    //Resizes the video view to fill the screen - aspect ratio for the camera does not match the screen.
                    previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
                    //Making sure everything lines up.
                    previewLayer!.frame = viewView.bounds
                    
                    captureSession!.startRunning()
                }
            }
        }
        catch
        {
            print(error)
        }

    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
   
           }

    
    override func viewDidAppear(animated: Bool)
    {
       super.viewDidAppear(animated)

        
        
    }
   
    
    @IBAction func onButtonTapped(sender: UIButton)
    {
        if let videoConnection = stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo)
        {

/**
The following, commented out code threw an error re: the completion handler. 
             
             2016-06-09 20:38:54.944 CustomCamera[4707:1591611]  Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: ' -[AVCaptureStillImageOutput captureStillImageAsynchronouslyFromConnection:completionHandler:] - inconsistent state.'

the code directly below it was copied verbatum from the sample code linked in the tutorial I used as a base (see top of VC) Apparently that if statement is vital.

            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(sampleBuffer, error) in
                
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                let dataProvider = CGDataProviderCreateWithCFData(imageData)
                let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
                
                let image = UIImage(CGImage: cgImageRef!)
                
                self.imageView.image = image
                
            })
 **/
            
            videoConnection.videoOrientation = AVCaptureVideoOrientation.Portrait
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(sampleBuffer, error) in
                if (sampleBuffer != nil) {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
                    
                    let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                    self.imageView.image = image
                }
            })
        }
        
    }


    
    
    
    
    
    
 //Look, I am under the impression that custom cameras can cause memory allocation issues, I'm keeping this.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        print("What the frickle-frack?")
    }

}

