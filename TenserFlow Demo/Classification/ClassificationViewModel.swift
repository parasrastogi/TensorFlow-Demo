//
//  ClassificationViewModel.swift
//  TenserFlow Demo
//
//  Created by Paras Rastogi on 04/01/21.
//

import Foundation
import  Bond
import ReactiveKit

class ClassificationViewModel{
    
    var widht = Observable<String>("")
    var height = Observable<String>("")
    var blurry = Observable<Bool>(false)
    var mainlabelName = Observable<String>("")
    var subLabelName = Observable<String>("")
    var mainLabelPerc = Observable<Float>(0)
    var subLabelPerc = Observable<Float>(0)
    var allResponse : AllResponse? = nil
    
    func refreshData(allResponse : AllResponse){
        widht.value = String(allResponse.result.metaInfo.width)
        height.value = String(allResponse.result.metaInfo.height)
        mainlabelName.value = String(allResponse.result.classification.labels[0].name)
        blurry.value = allResponse.result.quality.isBlur
        subLabelName.value = String( allResponse.result.classification.subLabel.count > 0 ? allResponse.result.classification.subLabel[0].name : "")
        mainLabelPerc.value = allResponse.result.classification.labels[0].prob
        subLabelPerc.value = allResponse.result.classification.subLabel.count > 0 ? allResponse.result.classification.subLabel[0].prob : 0
        
    }
}
