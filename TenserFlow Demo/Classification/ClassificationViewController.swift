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
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var subLabelProb: UIProgressView!
    @IBOutlet weak var subPercLabel: UILabel!
    @IBOutlet weak var mainProgressView: UIProgressView!
    @IBOutlet weak var subProgressView: UIProgressView!
    
    var classificationViewModel : ClassificationViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         bindViewModel()
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
            vc.subProgressView.progress = value
            vc.subPercLabel.text = String(format: "%.2f%%", value * 100)
        }
     
        classificationViewModel.subLabelName.observeNext { (sublabelName) in
            if sublabelName.isEmpty{
                self.subLabel.isHidden = true
                self.subLabelProb.isHidden = true
                self.subPercLabel.isHidden = true
              
            }else{
                self.subLabel.isHidden = false
                self.subLabelProb.isHidden = false
                self.subPercLabel.isHidden = false
                self.subLabel.text = sublabelName
            }
        }.dispose(in: bag)

    }

}
