//
//  ViewController.swift
//  Egret
//
//  Created by wangwenjie on 2020/3/13.
//  Copyright © 2020 wangwenjie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func uploadCertificate(_ sender: Any) {
        navigationController?.pushViewController(PhotoIndexViewController(), animated: true)
    }
    
}

