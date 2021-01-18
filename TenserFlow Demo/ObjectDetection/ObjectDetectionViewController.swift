//
//  ObjectDetectionViewController.swift
//  TenserFlow Demo
//
//  Created by Paras Rastogi on 05/01/21.
//
import UIKit
import TagListView

class ObjectDetectionViewController: UIViewController {
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var sliderValueLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    var objectDetectionViewModel: ObjectDetectionViewModel!
    var onTagTapHandler: ((Int) -> Void)?
    var sliderChangedHandler: ((Float) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        tagListView.delegate = self
    }
    
    @IBAction func objectProbSliderChanged(_ sender: UISlider) {
        let roundedVal = Double(round(100*sender.value)/100) // round 2 decimal places
        sliderValueLabel.text = String(format: "%.2f%%", roundedVal)
        if let sliderChangedHandler = sliderChangedHandler{
            sliderChangedHandler(Float(roundedVal))
            changeTabButtonColorOnSlide(Float(roundedVal))
        }
    }
    
    
    
    func changeTabButtonColorOnSlide(_ value: Float){
        for (index,obj) in  objectDetectionViewModel.objectsList.enumerated(){
            if obj.prob >= value{
                tagListView.tagViews[index].isSelected = false
            }else{
                tagListView.tagViews[index].isSelected = true
            }
        }
    }
    
    func bindViewModel(){
        objectDetectionViewModel.mainLabels.bind(to: self) { (vc, list) in
            vc.tagListView.removeAllTags()
            for (index,value) in list.collection.enumerated() {
                let tagView =   vc.tagListView.addTag(value)
                tagView.tag = index
                tagView.onLongPress = nil
            }
            vc.tagListView.textFont = UIFont.systemFont(ofSize: 16)
        }
        
        objectDetectionViewModel.maxValOfSlider.observeNext { [weak self] (maxVal) in
            self?.slider.maximumValue = maxVal
            self?.slider.value = maxVal - 0.05
            self?.sliderValueLabel.text = String(format: "%.2f%%", self?.slider.value as! CVarArg)
        }.dispose(in: bag)
        
    }
}

extension ObjectDetectionViewController: TagListViewDelegate{
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        if let onTagTapHandler = onTagTapHandler{
            onTagTapHandler(tagView.tag)
            tagView.isSelected = !tagView.isSelected
            debugPrint(tagView.isSelected)
        }
    }
}
