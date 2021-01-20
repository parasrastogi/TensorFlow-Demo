//
//  ObjectDetectionViewModel.swift
//  TenserFlow Demo
//
//  Created by Paras Rastogi on 05/01/21.
//

import Foundation
import Bond
import ReactiveKit

class ObjectDetectionViewModel: CategoryViewModelItem {
    var type: CategoryViewModelItemType{
        return .objectDetection
    }
    
    var sectionTitle: String{
        "Object Detection"
    }
    
    let mainLabels = MutableObservableArray<String>([])
    let maxValOfSlider = Observable<Float>(0)
    var objectsList = [Object]([])
    let currentValOfSlider = Observable<Float>(0)

func refreshData(allResponse: AllResponse){
    mainLabels.removeAll()
    objectsList = allResponse.result?.objectDetection.objects ?? []
    let allLabels = objectsList.map { $0.mainLabel}
    mainLabels.insert(contentsOf: allLabels, at: 0)
    maxValOfSlider.value =  objectsList.map { $0.prob }.max() ?? 0.0
    debugPrint(maxValOfSlider.value)
}
}
