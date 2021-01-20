//
//  ImageQualityTableViewCell.swift
//  TenserFlow Demo
//
//  Created by Paras Rastogi on 19/01/21.
//

import UIKit

class ImageQualityTableViewCell: UITableViewCell {
    @IBOutlet weak var imageQualityLabel: UILabel!
    @IBOutlet weak var constructionLabel: UILabel!
    @IBOutlet weak var blurryLabel: UILabel!
    @IBOutlet weak var lineDrawingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(_ viewModel: ImageQualityViewModel){
        viewModel.imageQuality.bind(to: imageQualityLabel)
        viewModel.construction.observeNext { (value) in
                self.constructionLabel.text = value.description
            }.dispose(in: bag)
        viewModel.lineDrawing.observeNext { (value) in
                self.lineDrawingLabel.text = value.description
            }.dispose(in: bag)
        viewModel.blurry.observeNext { (value) in
                self.blurryLabel.text = value.description
            }.dispose(in: bag)
    }
    


}
