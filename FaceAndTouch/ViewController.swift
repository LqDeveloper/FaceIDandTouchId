//
//  ViewController.swift
//  FaceAndTouch
//
//  Created by Quan Li on 2019/4/12.
//  Copyright © 2019 williamoneilchina. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UserIdentifyDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        UserIdentifyManager.shared.delegate = self
        
        UserIdentifyManager.shared.identifyUser(policy: .deviceOwnerAuthenticationWithBiometrics, localizedReason: "这是打印的数据")
    }
    
    func identifyUserResult(state: UserIdentifyState, error: Error?) {
        if state == .Success{
            print("验证成功")
        }else{
            guard let err = error else{
                return
            }
            print("错误信息 \(err.localizedDescription)")
        }
    }

}

