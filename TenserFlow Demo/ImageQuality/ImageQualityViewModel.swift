//
//  ImageQualityViewModel.swift
//  TenserFlow Demo
//
//  Created by Paras Rastogi on 05/01/21.
//

import Foundation
import Bond
import ReactiveKit

class ImageQualityViewModel {
    
    var imageQuality = Observable<String>("")
    var construction = Observable<Bool>(false)
    var blurry = Observable<Bool>(false)
    var lineDrawing = Observable<Bool>(false)
    
    func refreshData(allResponse: AllResponse){
        imageQuality.value = allResponse.result.quality.qualityScale
        construction.value = allResponse.result.quality.construction
        blurry.value = allResponse.result.quality.isBlur
        lineDrawing.value = allResponse.result.quality.isLineDrawing
    }
}


