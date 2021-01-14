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
    @IBOutlet weak var sliderValue: UILabel!
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
        print(sender.value)
        sliderValue.text = String(format: "%.2f", sender.value)
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
