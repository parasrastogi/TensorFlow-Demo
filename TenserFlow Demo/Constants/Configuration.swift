//
//  Configuration.swift
//  TenserFlow Demo
//
//  Created by Paras Rastogi on 28/12/20.
//

import Foundation
import DeviceKit
var isIPAD = Platform.device.isPad
struct Platform {
    
    static var device = Device.current
    
    static var isIpadPro12Inch = Platform.device.isOneOf([
        .iPadPro12Inch,
        .iPadPro12Inch2,
        .iPadPro12Inch3,
        .iPadPro12Inch4,
        .simulator(.iPadPro12Inch),
        .simulator(.iPadPro12Inch2),
        .simulator(.iPadPro12Inch3),
        .simulator(.iPadPro12Inch4)])
    
    static var isIPhone4inch = Platform.device.isOneOf([.iPhone5,
                                                        .iPhone5c,
                                                        .iPhone5s,
                                                        .iPhoneSE,
                                                        .simulator(.iPhone5),
                                                        .simulator(.iPhone5c),
                                                        .simulator(.iPhone5s),
                                                        .simulator(.iPhoneSE)])
    
    static var isIPhone7Category = Platform.device.isOneOf([.iPhone6,
                                                           .iPhone6s,
                                                           .iPhone7,
                                                           .iPhone8,
                                                           .iPhoneSE2,
                                                           .simulator(.iPhone6),
                                                           .simulator(.iPhone6s),
                                                           .simulator(.iPhone7),
                                                           .simulator(.iPhone8),
                                                           .simulator(.iPhoneSE2)])
    
}
