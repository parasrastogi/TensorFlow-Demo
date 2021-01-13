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
    var objectDetectionViewModel: ObjectDetectionViewModel!
    var onTagTapHandler: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objectDetectionViewModel.mainLabels.bind(to: self) { (vc, list) in
            vc.tagListView.removeAllTags()
            for (index,value) in list.collection.enumerated() {
                let tagView =   vc.tagListView.addTag(value)
                tagView.tag = index
                tagView.onLongPress = nil
            }
            vc.tagListView.textFont = UIFont.systemFont(ofSize: 16)
        }
        tagListView.delegate = self
        
    
    }
    
}

extension ObjectDetectionViewController: TagListViewDelegate{
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        debugPrint(tagView.tag)
        if let onTagTapHandler = onTagTapHandler{
            onTagTapHandler(tagView.tag)
            tagView.isSelected = !tagView.isSelected
            debugPrint(tagView.isSelected)
        }
    }
}
