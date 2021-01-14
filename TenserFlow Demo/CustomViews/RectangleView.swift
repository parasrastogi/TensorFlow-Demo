//
//  RectangleView.swift
//  TenserFlow Demo
//
//  Created by Paras Rastogi on 11/01/21.
//

import Foundation
import UIKit

class RectangleView : UIView{
    var rectColorArray = [UIColor.green, UIColor.blue, UIColor.red, UIColor.yellow, UIColor.systemPink]
    static var objectAndColorDic = [String : UIColor]()
    var label: UILabel = UILabel()
    var title: String = ""
    static var index = 0
    init( name: String, frame: CGRect) {
        super.init(frame: frame)
        title = name
        label.text = title
        addCustomView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addCustomView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addCustomView()
    }

    func addCustomView() {
        //label.frame = CGRect(x: 100, y: 10, width: 200, height: 100)
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.backgroundColor=UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.blue
        self.clipsToBounds = false
        self.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        let TopConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        
        let verticalConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 4)
           self.addConstraints([TopConstraint, verticalConstraint])
        configureBorderColor()
    }
    
    func configureBorderColor(){
        //        let red = CGFloat(Character(title[0]).asciiValue ?? 0)
        //        let blue = CGFloat(Character(title[1]).asciiValue ?? 0)
        //       let green = CGFloat(Character(title[2]).asciiValue ?? 0)
        var color: UIColor
        if let val = RectangleView.objectAndColorDic[title]{
            color = val
        }else{
            if RectangleView.index >= rectColorArray.count - 1 {
                RectangleView.index = 0
            }
            RectangleView.objectAndColorDic[title.trimmingCharacters(in: .whitespacesAndNewlines) ]  = rectColorArray[RectangleView.index]
            color = RectangleView.objectAndColorDic[title] ?? .black
            RectangleView.index = RectangleView.index + 1
            //color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
        
        self.layer.borderColor = color.cgColor
        // self.layer.borderColor = uiColor.cgColor
    }
}
