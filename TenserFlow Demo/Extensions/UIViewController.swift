//
//  UIViewController.swift
//  TenserFlow Demo
//
//  Created by Paras Rastogi on 04/01/21.
//

import UIKit

extension UIViewController {
    func addChildViewController(viewController: UIViewController?, containerView: UIView) {
          guard let contentVC = viewController else { return }
              self.addChild(contentVC)
              let destView = contentVC.view
              destView?.frame = CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: containerView.frame.size.height)
              containerView.addSubview(destView!)
        destView?.translatesAutoresizingMaskIntoConstraints = true
        destView?.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleRightMargin, .flexibleBottomMargin, .flexibleLeftMargin]
             // containerView.updateConstraint(subView: destView!)
              contentVC.didMove(toParent: self)
      }
}
