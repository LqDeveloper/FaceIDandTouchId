//
//  UserIdentifyManager.swift
//  FaceAndTouch
//
//  Created by Quan Li on 2019/4/12.
//  Copyright © 2019 williamoneilchina. All rights reserved.
//

import UIKit
import LocalAuthentication

enum UserIdentifyState:Int,CaseIterable{
    
    /// TouchID/FaceID 验证成功
    case Success = 0
    
    
    /// 当前设备不支持TouchID/FaceID
    case NotSupport = 1
    
    
    /// TouchID/FaceID 验证失败
    case Fail = 2
}

protocol UserIdentifyDelegate:AnyObject {
    func identifyUserResult(state:UserIdentifyState,error:Error?)
}
// LAPolicyDeviceOwnerAuthenticationWithBiometrics: 用TouchID/FaceID验证
// LAPolicyDeviceOwnerAuthentication: 用TouchID/FaceID或密码验证, 默认是错误两次或锁定后, 弹出输入密码界面


class UserIdentifyManager: NSObject {
    static let shared = UserIdentifyManager()
    
    weak var delegate:UserIdentifyDelegate?
    
    func isIphoneXSeries() -> Bool {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets.bottom  ?? 0 > 0
        }
        return false
    }
    
    func identifyUser(policy:LAPolicy,localizedReason:String)  {
        let system_Version = Float(UIDevice.current.systemVersion)!
        if system_Version < 8.0{
            self.callBack(state: UserIdentifyState.NotSupport, error: nil)
        }
        
        let context = LAContext.init()
        var error:NSError?
        
        
        guard context.canEvaluatePolicy(policy, error: &error) else {
            self.callBack(state: UserIdentifyState.NotSupport, error: error)
            return
        }
        
        context.evaluatePolicy(policy, localizedReason: localizedReason) { (success, error) in
            if success{
                self.callBack(state: UserIdentifyState.Success, error: nil)
            }else{
                self.callBack(state: UserIdentifyState.Fail, error: error)
            }
        }
    }
    func callBack(state:UserIdentifyState,error:Error?) {
        DispatchQueue.main.async {
            self.delegate?.identifyUserResult(state: state, error: error)
        }
    }
}
