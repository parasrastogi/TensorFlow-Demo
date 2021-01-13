//
//  UtilityManager.swift
//  TenserFlow Demo
//
//  Created by Paras Rastogi on 28/12/20.
//

import Foundation
import AVFoundation
import UIKit
import Photos
import SVProgressHUD

public let partnerName = "NewHomeSource"

class UtilityManager: NSObject{
    typealias CompletionBlock = (() -> Void)
    static func checkCameraPermission(with permissionMessage: String, inViewcontroller: UIViewController? = nil, completionHandler: @escaping () -> Void) {
        //"Camera access required for capturing photos!"
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus {
        case .authorized, .notDetermined: completionHandler()
        default: alertToEncourageCameraAccessInitially(with: permissionMessage, viewController: inViewcontroller)
        }
    }
    
    struct Buttonconfiguration {
        let title: String
        let action: CompletionBlock?
        let buttonStyle: UIAlertAction.Style
        
        init(title: String, action: CompletionBlock?, buttonStyle: UIAlertAction.Style = .default) {
            self.title = title
            self.action = action
            self.buttonStyle = buttonStyle
        }
    }
    
    static func alertToEncourageCameraAccessInitially(with permissionMessage: String, viewController: UIViewController? = nil) {
        let camPermissionMessage = (Bundle.main.infoDictionary?["NSCameraUsageDescription"] as? String) ?? permissionMessage
        
        let alert = UIAlertController(
            title: "\"\(partnerName)\" Would Like to Access the Camera",
            message: camPermissionMessage,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow", style: .cancel, handler: {_ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }))
        if let viewController = viewController {
            viewController.present(alert, animated: true, completion: nil)
        } else {
            if let rootController = AppDelegate.sharedDelegate().window?.rootViewController {
                rootController.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    static func checkPhotoLibraryPermission(with permissionMessage: String, inViewcontroller: UIViewController? = nil, completionHandler: @escaping () -> Void) {
        //"Photos access required for adding photos!"
        let authStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus {
        case .authorized, .notDetermined: completionHandler()
        default: alertToEncouragePhotosAccessInitially(with: permissionMessage, viewController: inViewcontroller)
        }
    }
    
    static func alertToEncouragePhotosAccessInitially(with permissionMessage: String, viewController: UIViewController? = nil) {
        let photoGalleryPermissionMessage = (Bundle.main.infoDictionary?["NSPhotoLibraryUsageDescription"] as? String) ?? permissionMessage
        
        let alert = UIAlertController(
            title: "\"\(partnerName)\" Would Like to Access Your Photos",
            message: photoGalleryPermissionMessage,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow", style: .cancel, handler: { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }))
        
        if let viewController = viewController {
            viewController.present(alert, animated: true, completion: nil)
        } else {
            if let rootController = AppDelegate.sharedDelegate().window?.rootViewController {
                rootController.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    static func showAlert(title: String?, message: String?, controller: UIViewController, buttonconfigs: [Buttonconfiguration]) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        buttonconfigs.forEach { (config) in
            let action =  UIAlertAction(title: config.title, style: .default) { (_) -> Void in
                if let completionBlock = config.action {
                    completionBlock()
                }
            }
            
            if config.buttonStyle == .cancel {
                action.setValue(UIColor.blue, forKey: "titleTextColor")
            }
            
            alertViewController.addAction(action)
            
        }
        controller.present(alertViewController, animated: true, completion: nil)
    }
    
    static func showAlert(title: String?, message: String?, controller: UIViewController, showCancel: Bool = false) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) -> Void in }
        if showCancel {
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) -> Void in }
            alertViewController.addAction(cancelAction)
        }
        alertViewController.addAction(okAction)
        
        controller.present(alertViewController, animated: true, completion: nil)
    }
    
    /// Hide Progress indicator with status
    static func showProgress(status: String) {
        OperationQueue.main.addOperation {
            if !SVProgressHUD.isVisible() {
                UIApplication.shared.beginIgnoringInteractionEvents()
                SVProgressHUD.show(withStatus: status)
            }
        }
    }
    
    /// Hide Progress indicator
    static func hideProgress() {
        OperationQueue.main.addOperation {
            UIApplication.shared.endIgnoringInteractionEvents()
            SVProgressHUD.dismiss()
        }
    }
}
