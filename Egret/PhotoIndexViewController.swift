//
//  PhotoIndexViewController.swift
//  Egret
//
//  Created by wangwenjie on 2020/3/31.
//  Copyright © 2020 wangwenjie. All rights reserved.
//

import UIKit

class PhotoIndexViewController: UIViewController {

    @IBOutlet weak var showImv: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Action
    
    @IBAction func IDCardFornt(_ sender: Any) {
        
        let vc = CameraController(type: .ID, idType: .front)
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)

    }
    
    @IBAction func IDCardBlack(_ sender: Any) {
        let vc = CameraController(type: .ID, idType: .reverse)
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)

    }
    
    @IBAction func componyVertical(_ sender: Any) {
        let vc = CameraController(type: .BL, blType: .horizontal)
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)

    }
    
    @IBAction func componyHorizontal(_ sender: Any) {
        let vc = CameraController(type: .BL, blType: .vertical)
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)

    }
    
    @IBAction func meta(_ sender: Any) {
        let vc = MetaViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

extension PhotoIndexViewController: CameraControllerProtocol {
    func cameraDidFinishShootWithCameraImage(image: UIImage) {
        showImv.image = image
    }
    
    
}
