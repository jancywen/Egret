//
//  CameraFloatingView.swift
//  CameraDemo
//
//  Created by wangwenjie on 2020/3/31.
//  Copyright © 2020 shangZhu. All rights reserved.
//

import UIKit

let isIPhone5or5cor5sorSE: Bool = UIScreen.main.bounds.size.height == 568.0
let isIPhone6or6sor7: Bool = UIScreen.main.bounds.size.height == 667.0
let kScreenW = UIScreen.main.bounds.size.width
let kScreenH = UIScreen.main.bounds.size.height

class CameraFloatingView: UIView {
    fileprivate var type: CameraType  = .ID
    fileprivate var idType: IDCardType = .front
    fileprivate var blType: BLType = .horizontal
    lazy var WindowLayer: CAShapeLayer = {
        let windowLayer = CAShapeLayer.init()
        windowLayer.position = self.layer.position
        windowLayer.cornerRadius = 15
        windowLayer.borderColor = UIColor.white.cgColor
        windowLayer.borderWidth = 2
        return windowLayer
    }()
    
    lazy var resouceBundle: Bundle = {
        let path = Bundle.init(for: self.classForCoder).path(forResource: "Camera", ofType: "bundle")
        let bundle = Bundle.init(path: path!)
        return bundle!
    }()
    
    convenience init(type: CameraType, idType: IDCardType = .front, blType: BLType = .horizontal) {
        self.init(frame: UIScreen.main.bounds)
        self.type = type
        self.idType = idType
        self.blType = blType
        
        
        backgroundColor = UIColor.clear
        let width: CGFloat = isIPhone5or5cor5sorSE ? 240: (isIPhone6or6sor7 ? 240: 270)
        WindowLayer.bounds = CGRect.init(x: 0, y: 0, width: width, height: width*1.414)
        self.layer.addSublayer(WindowLayer)
        // 最里层镂空
        let transparentRoundedRectPath: UIBezierPath = UIBezierPath.init(roundedRect: WindowLayer.frame, cornerRadius: WindowLayer.cornerRadius)
        
        // 最外层背景
        let path = UIBezierPath.init(rect: UIScreen.main.bounds)
        path.append(transparentRoundedRectPath)
        path.usesEvenOddFillRule = true
        
        let fillLayer = CAShapeLayer.init()
        fillLayer.path = path.cgPath
        fillLayer.fillRule = .evenOdd
        fillLayer.fillColor = UIColor.black.cgColor
        fillLayer.opacity = 0.6
        self.layer.addSublayer(fillLayer)
        
        // 提示标签
        let textLabel = UILabel()
        let text = type == .BL ? "对齐营业执照并点击拍照" : (idType == .front ? "对齐身份证正面并点击拍照": "对齐身份证背面并点击拍照")
        textLabel.text = text
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 14)
        textLabel.textColor = UIColor.white
        self.addSubview(textLabel)
        
        let w: CGFloat = kScreenH
        let h: CGFloat = 20
        let x: CGFloat = (kScreenW-w)/2-WindowLayer.frame.width/2-20
        let y: CGFloat = (kScreenH-h)/2
        textLabel.frame = CGRect.init(x: x, y: y, width: w, height: h)
        textLabel.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi*0.5)
        
        var facePathWidth: CGFloat = 0
        var facePathHeight: CGFloat = 0
        var image: UIImage!
        
        switch type {
        case .ID:
            if idType == .front {
                facePathWidth = isIPhone5or5cor5sorSE ? 95: (isIPhone6or6sor7 ? 120: 150)
                facePathHeight = facePathWidth * 0.812
                image = UIImage.init(contentsOfFile: resouceBundle.path(forResource: "xuxian@2x", ofType: "png")!)
            }else{
                facePathWidth = isIPhone5or5cor5sorSE ? 40: (isIPhone6or6sor7 ? 80: 100)
                facePathHeight = facePathWidth
                image = UIImage.init(contentsOfFile: resouceBundle.path(forResource: "Page 1@2x", ofType: "png")!)
            }
            // 国徽、头像
            let imageView = UIImageView.init(image: image)
            imageView.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi * 0.5)
            imageView.contentMode = .scaleAspectFill
            addSubview(imageView)
            
            var imageX: CGFloat = 0
            var imageY: CGFloat = 0
            let imageW: CGFloat = facePathWidth
            let imageH: CGFloat = facePathHeight
            if idType == .front {
                imageX = (kScreenW-imageW)/2
                imageY = (kScreenH - imageH)/2 + WindowLayer.frame.height/2 - facePathWidth/2 - 30
            }else{
                imageX = (kScreenW-imageW)/2+WindowLayer.frame.width/2 - facePathHeight/2 - 25;
                imageY = (kScreenH - imageH)/2-WindowLayer.frame.height/2 + facePathWidth/2 + 20
            }
            imageView.frame = CGRect.init(x: imageX, y: imageY, width: imageW, height: imageH)
        case .BL:
            facePathWidth = isIPhone5or5cor5sorSE ? 40: (isIPhone6or6sor7 ? 80: 100)
            facePathHeight = facePathWidth
            image = UIImage.init(contentsOfFile: resouceBundle.path(forResource: "Page 1@2x", ofType: "png")!)
            // 国徽
            let imageView = UIImageView.init(image: image)
            imageView.contentMode = .scaleAspectFill
            addSubview(imageView)
            
            var imageX: CGFloat = 0
            var imageY: CGFloat = 0
            let imageW: CGFloat = facePathWidth
            let imageH: CGFloat = facePathHeight
            if blType == .horizontal {
                imageView.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi * 0.5)
                imageX = (kScreenW-imageW)/2+WindowLayer.frame.width/2 - facePathHeight/2 - 25
                imageY = (kScreenH - imageH)/2
            }else{
                imageX = (kScreenW-imageW)/2
                imageY = (kScreenH - imageH)/2-WindowLayer.frame.height/2 + facePathWidth/2 + 20
            }
            imageView.frame = CGRect.init(x: imageX, y: imageY, width: imageW, height: imageH)
        }
    }
    
}
