//
//  ClassificationViewController.swift
//  TenserFlow Demo
//
//  Created by Paras Rastogi on 02/01/21.
//

import UIKit
import Bond
import ReactiveKit

class ClassificationViewController: UIViewController {

    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var isBlureLabel: UILabel!
    @IBOutlet weak var isLineDrawingLable: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var MainLabelProb: UIProgressView!
    @IBOutlet weak var mainPercLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var subLabelStackView: UIStackView!
    @IBOutlet weak var subTitlePercLabel: UILabel!
    @IBOutlet weak var mainProgressView: UIProgressView!
    @IBOutlet weak var subTitleProgressView: UIProgressView!
    
    var classificationViewModel : ClassificationViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         bindViewModel()
        self.view.layoutIfNeeded()
        self.parent?.view.layoutIfNeeded()
    }

    func bindViewModel(){
        classificationViewModel.height.bind(to: heightLabel)
        classificationViewModel.widht.bind(to: widthLabel)
        classificationViewModel.mainlabelName.bind(to: mainLabel)
        classificationViewModel.blurry.observeNext { (value) in
            self.isBlureLabel.text = value.description
        }.dispose(in: bag)
        classificationViewModel.mainLabelPerc.bind(to: self) { (vc, value) in
            vc.mainProgressView.progress = value
            vc.mainPercLabel.text = String(format: "%.2f%%", value * 100)
        }

        classificationViewModel.subLabelPerc.bind(to: self) { (vc, value) in
            vc.subTitleProgressView.progress = value
            vc.subTitlePercLabel.text = String(format: "%.2f%%", value * 100)
        }
     
        classificationViewModel.subLabelName.observeNext { (sublabelName) in
            if sublabelName.isEmpty{
                self.subLabelStackView.isHidden = true
                self.subTitleProgressView.isHidden = true
            }else{
                self.subLabelStackView.isHidden = false
                self.subTitleLabel.text = sublabelName
                self.subTitleProgressView.isHidden = false
            }
        }.dispose(in: bag)

    }

}
