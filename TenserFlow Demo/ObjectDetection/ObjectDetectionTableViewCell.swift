//
//  ObjectDetectionTableViewCell.swift
//  TenserFlow Demo
//
//  Created by Paras Rastogi on 19/01/21.
//

import UIKit
import TagListView

class ObjectDetectionTableViewCell: UITableViewCell {
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var sliderValueLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    var viewModel: ObjectDetectionViewModel!
    var tabVC: TabViewController?
    var onTagTapHandler: ((Int) -> Void)?
    var sliderChangedHandler: ((Float) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tagListView.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setData(_ viewModel: ObjectDetectionViewModel, viewController: TabViewController){
        self.viewModel = viewModel
        self.tabVC = viewController
        viewModel.mainLabels.bind(to: self) { (vc, list) in
            vc.tagListView.removeAllTags()
            for (index,value) in list.collection.enumerated() {
                let tagView =   vc.tagListView.addTag(value)
                tagView.tag = index
                tagView.onLongPress = nil
            }
            vc.tagListView.textFont = UIFont.systemFont(ofSize: 16)
        }
        
        viewModel.maxValOfSlider.observeNext { [weak self] (maxVal) in
            let roundedVal = Double(round(100 * maxVal)/100)
            self?.slider.maximumValue = Float(roundedVal)
            self?.viewModel.currentValOfSlider.value = Float(roundedVal - 0.05)
            if let sliderChangedHandler = self?.sliderChangedHandler{
                sliderChangedHandler(self?.viewModel.currentValOfSlider.value ?? 0)
                self?.changeTabButtonColorOnSlide(self?.viewModel.currentValOfSlider.value ?? 0)
            }
            
        }.dispose(in: bag)
        
        viewModel.currentValOfSlider.observeNext { [weak self] (currVal) in
            self?.slider.value = currVal
            self?.sliderValueLabel.text = String(format: "%.2f%", self?.slider.value as! CVarArg)
        }.dispose(in: bag)
        
        
        if let tabVC = tabVC{
            tabVC.changeSliderValueOnTagTapHandler = {[weak self] confidenceValue in
                self?.viewModel.currentValOfSlider.value = confidenceValue
            }
        }
    }
        @IBAction func objectProbSliderChanged(_ sender: UISlider) {
            let roundedVal = Double(round(100*sender.value)/100) // round 2 decimal places
            sliderValueLabel.text = String(format: "%.2f%", roundedVal)
            if let sliderChangedHandler = sliderChangedHandler{
                sliderChangedHandler(Float(roundedVal))
                changeTabButtonColorOnSlide(Float(roundedVal))
            }
        }
        
        
        
        func changeTabButtonColorOnSlide(_ value: Float){
            for (index,obj) in  viewModel.objectsList.enumerated(){
                if obj.prob >= value{
                    tagListView.tagViews[index].isSelected = false
                }else{
                    tagListView.tagViews[index].isSelected = true
                }
            }
        }
    }

extension ObjectDetectionTableViewCell: TagListViewDelegate{
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        if let onTagTapHandler = onTagTapHandler{
            onTagTapHandler(tagView.tag)
            tagView.isSelected = !tagView.isSelected
            debugPrint(tagView.isSelected)
        }
    }
}







