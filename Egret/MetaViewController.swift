//
//  MetaViewController.swift
//  Egret
//
//  Created by wangwenjie on 2020/3/31.
//  Copyright © 2020 wangwenjie. All rights reserved.
//

import UIKit
import AVFoundation

class MetaViewController: UIViewController {

    var barCode: UIView! {
        get {
            return UIView(frame: CGRect(x: 20, y: 160, width: 180, height: 40))
        }
    }
    /// 扫描相关
    var device:AVCaptureDevice!
    var input:AVCaptureDeviceInput!
    var output:AVCaptureMetadataOutput!
    var session:AVCaptureSession!
    var preview:AVCaptureVideoPreviewLayer!

    
    var callBack: ((String?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fromCamera()
        
    }
}


extension MetaViewController:AVCaptureMetadataOutputObjectsDelegate,
UIAlertViewDelegate {
    //通过摄像头扫描
    func fromCamera() {
        do{
            self.device = AVCaptureDevice.default(for: AVMediaType.video)
             
            self.input = try AVCaptureDeviceInput(device: device)
             
            self.output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
             
            self.session = AVCaptureSession()
            if UIScreen.main.bounds.size.height<500 {
                self.session.sessionPreset = AVCaptureSession.Preset.vga640x480
            }else{
                self.session.sessionPreset = AVCaptureSession.Preset.high
            }
             
            self.session.addInput(self.input)
            self.session.addOutput(self.output)
             
//            self.output.metadataObjectTypes = [AVMetadataObject.ObjectType.ean13,
//                                               AVMetadataObject.ObjectType.ean8,
//                                               AVMetadataObject.ObjectType.code128,
//                                               AVMetadataObject.ObjectType.code39,
//                                               AVMetadataObject.ObjectType.code93]
            ///所有解析类型
            self.output.metadataObjectTypes = self.output.availableMetadataObjectTypes
             
            //计算中间可探测区域
            let windowSize = UIScreen.main.bounds.size
            
            let window = UIApplication.shared.delegate?.window
            var scanRect = self.view.convert(self.view.bounds, to: window!)
            
            //计算rectOfInterest 注意x,y交换位置
            scanRect = CGRect(x:scanRect.origin.y/windowSize.height,
                              y:scanRect.origin.x/windowSize.width,
                              width:scanRect.size.height/windowSize.height,
                              height:scanRect.size.width/windowSize.width);
            //设置可探测区域
            self.output.rectOfInterest = scanRect
             
            self.preview = AVCaptureVideoPreviewLayer(session:self.session)
            self.preview.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self.preview.frame = UIScreen.main.bounds
            self.view.layer.insertSublayer(self.preview, at:0)
             
            //开始捕获
            self.session.startRunning()
        }catch _ {
            //打印错误消息
            let alertController = UIAlertController(title: "提醒",
                        message: "请在iPhone的\"设置-隐私-相机\"选项中,允许本程序访问您的相机",
                        preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
     
    //摄像头捕获
     func metadataOutput(_ output: AVCaptureMetadataOutput,
                         didOutput metadataObjects: [AVMetadataObject],
                         from connection: AVCaptureConnection) {
        var stringValue:String?
        if metadataObjects.count > 0 {
            let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            stringValue = metadataObject.stringValue
            if stringValue != nil{
                self.session.stopRunning()
                draw(metadataObject)
            }
        }
        print(stringValue)
        callBack?(stringValue)
        self.session.stopRunning()
        self.dismiss(animated: true, completion: nil)
    }
    
    /// 绘制二维码中心
    
    func draw(_ object: AVMetadataMachineReadableCodeObject) {
        /// 转换坐标系
        let codeObject = preview.transformedMetadataObject(for: object) as! AVMetadataMachineReadableCodeObject
        
        let center = CGPoint(x: codeObject.bounds.origin.x + codeObject.bounds.size.width/2, y: codeObject.bounds.origin.y + codeObject.bounds.size.height/2)
        let rect = CGRect(x: center.x - 30, y: center.y - 30, width: 60, height: 60)
        
        
        UIView.animate(withDuration: 2) {
            let cgView = CGView(frame: rect)
            self.view.addSubview(cgView)
        }
        
    }
    
}


class CGView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        /// 创建并设置路径
        let path = CGMutablePath()
        // 绘制正圆
        let minWidth = min(self.bounds.width, self.bounds.height)
        path.addEllipse(in: CGRect(x: 3, y: 3, width: minWidth - 6, height: minWidth - 6))
        // 添加t路径到图形上下文
        context.addPath(path)
        
        // 设置笔触颜色
        context.setStrokeColor(UIColor.white.cgColor)
        // 设置笔触宽度
        context.setLineWidth(4)
        // 设置填充颜色
        context.setFillColor(UIColor.green.cgColor)
        // 绘制路径并填充
        context.drawPath(using: .fillStroke)
        
    }
    
}
