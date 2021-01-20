//
//  ClassificationTableViewCell.swift
//  TenserFlow Demo
//
//  Created by Paras Rastogi on 19/01/21.
//

import UIKit
import Bond
import ReactiveKit

class ClassificationTableViewCell: UITableViewCell {

    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var isBlureLabel: UILabel!
    @IBOutlet weak var isLineDrawingLable: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var mainPercLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var subLabelStackView: UIStackView!
    @IBOutlet weak var subTitlePercLabel: UILabel!
    @IBOutlet weak var mainProgressView: UIProgressView!
    @IBOutlet weak var subTitleProgressView: UIProgressView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(_ viewModel: ClassificationViewModel){
        viewModel.height.bind(to: heightLabel).dispose(in: bag)
        viewModel.widht.bind(to: widthLabel).dispose(in: bag)
        viewModel.mainlabelName.bind(to: mainLabel)
        viewModel.blurry.observeNext { (value) in
            self.isBlureLabel.text = value.description
        }.dispose(in: bag)
        viewModel.mainLabelPerc.bind(to: self) { (vc, value) in
            vc.mainProgressView.progress = value
            vc.mainPercLabel.text = String(format: "%.2f%%", value * 100)
        }.dispose(in: bag)

        viewModel.subLabelPerc.bind(to: self) { (vc, value) in
            vc.subTitleProgressView.progress = value
            vc.subTitlePercLabel.text = String(format: "%.2f%%", value * 100)
        }.dispose(in: bag)
     
        viewModel.subLabelName.observeNext { (sublabelName) in
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
