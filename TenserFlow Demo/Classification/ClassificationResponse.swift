//
//  ClassificationResponse.swift
//  TenserFlow Demo
//
//  Created by Paras Rastogi on 04/01/21.
//

import Foundation

//// MARK: - ClassificationResponse
// struct ClassificationResponse: Codable {
//    let result: Result
//    let status: Int
//
//    enum CodingKeys: String, CodingKey {
//        case result = "Result"
//        case status = "Status"
//    }
//}
//
//// MARK: - Result
//struct Result: Codable {
//    let classification: Classification
//    let metaInfo: MetaInfo
//
//    enum CodingKeys: String, CodingKey {
//        case classification = "Classification"
//        case metaInfo = "MetaInfo"
//    }
//}
//
//// MARK: - Classification
//struct Classification: Codable {
//    let labels, subLabel: [Label]
//
//    enum CodingKeys: String, CodingKey {
//        case labels = "Labels"
//        case subLabel = "SubLabel"
//    }
//}
//
//// MARK: - Label
//struct Label: Codable {
//    let id: Int
//    let name: String
//    let prob: Double
//
//    enum CodingKeys: String, CodingKey {
//        case id = "Id"
//        case name = "Name"
//        case prob = "Prob"
//    }
//}
//
//// MARK: - MetaInfo
//struct MetaInfo: Codable {
//    let apiVersion, dateTime: String
//    let height: Int
//    let imageContentURL: String
//    let imageSourceType: String
//    let sessionID, width: Int
//
//    enum CodingKeys: String, CodingKey {
//        case apiVersion = "APIVersion"
//        case dateTime = "DateTime"
//        case height = "Height"
//        case imageContentURL = "ImageContentUrl"
//        case imageSourceType = "ImageSourceType"
//        case sessionID = "SessionId"
//        case width = "Width"
//    }
//}
