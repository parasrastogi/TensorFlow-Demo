//
//  ObjectDetectionViewModel.swift
//  TenserFlow Demo
//
//  Created by Paras Rastogi on 05/01/21.
//

import Foundation
import Bond
import ReactiveKit

class ObjectDetectionViewModel {
    let mainLabels = MutableObservableArray<String>([])


func refreshData(allResponse: AllResponse){
    let objects =   allResponse.result.objectDetection.objects
    let allLabels = objects.map { $0.mainLabel}
    mainLabels.insert(contentsOf: allLabels, at: 0)
    
}
}
