//
//  TabBarCollectionViewCell.swift
//  TenserFlow Demo
//
//  Created by Paras Rastogi on 23/12/20.
//

import UIKit

class TabBarCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!

    class var identifier : String {
        return String( describing :self)
    }
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setSelected(status: Bool) {

        if status {
            titleLabel?.isHighlighted = true
            //titleLabel?.textColor = AppThemeColor.color1.color()
            bottomView?.backgroundColor = UIColor.blue
        } else {
            titleLabel?.isHighlighted = false
            bottomView?.backgroundColor = UIColor.clear
        }
    }

}
