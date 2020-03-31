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
    var fileOutput: AVCaptureFileOutput!
    var movieOutput: AVCaptureMovieFileOutput!
    
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
         let device = AVCaptureDevice.default(for: .video)
        /*
        /// 前置摄像头
        let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        /// 后置摄像头
        let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        /// 麦克风
        let mic = AVCaptureDevice.default(.builtInMicrophone, for: .audio, position: .unspecified)
        */
        do {
            deviceInput = try AVCaptureDeviceInput(device: device!)
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
        
        /// 视频输出
        movieOutput = AVCaptureMovieFileOutput()
        if let connection = movieOutput.connection(with: .video), connection.isVideoMirroringSupported {
            connection.preferredVideoStabilizationMode = .auto
//            connection.videoOrientation
        }
        if captureSession.canAddOutput(movieOutput) {
            captureSession.addOutput(movieOutput)
        }
        
        /// 预览
        let preLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        preLayer.frame = self.view.bounds
        preLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.view.layer.addSublayer(preLayer)
        
        /// 开始捕获画面
        captureSession.startRunning()
    }

///a开始录制
    func startRecordSession() {
        let url = URL(fileURLWithPath: NSTemporaryDirectory()+"temp.mp4")
        if FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.removeItem(at: url)
        }
        movieOutput.startRecording(to: url, recordingDelegate: self)
    }
    /// 结束录制
    func stopRecord() {
        movieOutput.stopRecording()
        captureSession.stopRunning()
    }
}

extension CaptureVideoViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        
    }
}

extension CaptureVideoViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print("开始录制")
    }
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("录制结束")
        print(outputFileURL)
        if let data = try? Data(contentsOf: outputFileURL) {
            print(data.count/1024/1024)
        }
        /// 压缩
        let time = Date().timeIntervalSince1970
        let path = NSTemporaryDirectory() + "\(time)"
        
        let asset = AVAsset(url: outputFileURL)
        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality)
        exportSession?.shouldOptimizeForNetworkUse = true
        exportSession?.outputURL = URL(fileURLWithPath: path)
        exportSession?.outputFileType = .mp4
        exportSession?.exportAsynchronously(completionHandler: {
            switch(exportSession?.status) {
            case .completed:
                if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                    print(data.count/1024/1024)
                }
            case .none:
                break
            case .some(_):
                break
            }
        })
    }
    
    
}
