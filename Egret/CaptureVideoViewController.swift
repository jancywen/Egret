//
//  CaptureVideoViewController.swift
//  Egret
//
//  Created by wangwenjie on 2020/3/13.
//  Copyright © 2020 wangwenjie. All rights reserved.
//

import UIKit
import AVFoundation


class CaptureVideoViewController: UIViewController {

    
    var captureSession: AVCaptureSession!
    var deviceInput: AVCaptureDeviceInput!
    var videoOutput: AVCaptureVideoDataOutput!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureSession = AVCaptureSession()
        captureSession.beginConfiguration()
        
        //设置分辨率
        if captureSession.canSetSessionPreset(.medium) {
            captureSession.sessionPreset = .medium
        }
        
        /// 设置输入端
        /// 默认返回后置摄像头
        /// let device = AVCaptureDevice.default(for: .video)
        /// 前置摄像头
        let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        /// 后置摄像头
        let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        /// 麦克风
        let mic = AVCaptureDevice.default(.builtInMicrophone, for: .audio, position: .unspecified)
        
        do {
            deviceInput = try AVCaptureDeviceInput(device: frontCamera!)
        } catch {
            print("get device input error")
        }
        
        if captureSession.canAddInput(deviceInput) {
            captureSession.addInput(deviceInput)
        }
        
        /// 设置输出端
        videoOutput = AVCaptureVideoDataOutput()
        videoOutput.alwaysDiscardsLateVideoFrames = false
        videoOutput.videoSettings = [kCVPixelBufferMetalCompatibilityKey as String: true,
                                     kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: Int32(kCVPixelFormatType_32BGRA))]
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
        
        captureSession.commitConfiguration()
        
        
        /// 设置代理
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global())
        
        /// 预览
        let preLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        preLayer.frame = self.view.bounds
        preLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.view.layer.addSublayer(preLayer)
        
        /// 开始捕获画面
        captureSession.startRunning()
    }


}

extension CaptureVideoViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        
    }
}
