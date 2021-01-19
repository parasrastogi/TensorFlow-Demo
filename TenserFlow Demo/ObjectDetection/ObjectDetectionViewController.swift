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
        if let parentVc = self.parent{
            if let tabVC = parentVc as? TabViewController{
                tabVC.changeSliderValueOnTagTapHandler = {[weak self] confidenceValue in
                    self?.objectDetectionViewModel.currentValOfSlider.value = confidenceValue
                }
            }
        }
    }
    
    @IBAction func objectProbSliderChanged(_ sender: UISlider) {
        let roundedVal = Double(round(100 * sender.value)/100) // round 2 decimal places
        sliderValueLabel.text = String(format: "%.2f%", roundedVal)
        if let sliderChangedHandler = sliderChangedHandler{
            sliderChangedHandler(Float(roundedVal))
            changeTabButtonColorOnSlide(Float(roundedVal))
        }
    }
    
    func changeTabButtonColorOnSlide(_ value: Float){
        for (index,obj) in  objectDetectionViewModel.objectsList.enumerated(){
            let roundedVal = Double(round(100 * obj.prob)/100)
            if Float(roundedVal) >= value{
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
        
        objectDetectionViewModel.minValOfSlider.observeNext { [weak self] (minVal) in
            let roundedVal = Double(round(100 * minVal)/100)
            self?.slider.minimumValue = Float(roundedVal)
        }.dispose(in: bag)
        
        objectDetectionViewModel.maxValOfSlider.observeNext { [weak self] (maxVal) in
            let roundedVal = Double(round(100 * maxVal)/100)
            self?.slider.maximumValue = Float(roundedVal)
            self?.objectDetectionViewModel.currentValOfSlider.value = Float(roundedVal - 0.05)
            if let sliderChangedHandler = self?.sliderChangedHandler{
                sliderChangedHandler(self?.objectDetectionViewModel.currentValOfSlider.value ?? 0)
                self?.changeTabButtonColorOnSlide(self?.objectDetectionViewModel.currentValOfSlider.value ?? 0)
            }
           
        }.dispose(in: bag)
       // objectDetectionViewModel.currentValOfSlider.bind(to: slider.reactive.value)
      //  objectDetectionViewModel.currentValOfSlider.bind(to: sliderValueLabel)
        
        objectDetectionViewModel.currentValOfSlider.observeNext { [weak self] (currVal) in
            self?.slider.value = currVal
            self?.sliderValueLabel.text = String(format: "%.2f%", self?.slider.value as! CVarArg)
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
