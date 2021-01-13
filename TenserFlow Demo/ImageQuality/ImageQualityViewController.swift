//
//  ImageQualityViewController.swift
//  TenserFlow Demo
//
//  Created by Paras Rastogi on 05/01/21.
//

import UIKit

class ImageQualityViewController: UIViewController {
    
    @IBOutlet weak var imageQualityLabel: UILabel!
    @IBOutlet weak var constructionLabel: UILabel!
    @IBOutlet weak var blurryLabel: UILabel!
    @IBOutlet weak var lineDrawingLabel: UILabel!
    var imageQualityViewModel: ImageQualityViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    func bindViewModel(){
        imageQualityViewModel.imageQuality.bind(to: imageQualityLabel)
        imageQualityViewModel.construction.observeNext { (value) in
            self.constructionLabel.text = value.description
        }.dispose(in: bag)
        imageQualityViewModel.lineDrawing.observeNext { (value) in
            self.lineDrawingLabel.text = value.description
        }.dispose(in: bag)
        imageQualityViewModel.blurry.observeNext { (value) in
            self.blurryLabel.text = value.description
        }.dispose(in: bag)
    }
    
}


