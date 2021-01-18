import Foundation

// MARK: - Welcome
struct AllResponse: Codable {
    let result: Result?
    let status: Int
    let error: Error?
    
    enum CodingKeys: String, CodingKey {
        case result = "Result"
        case status = "Status"
        case error = "Error"
    }
}

// MARK: - Result
struct Result: Codable {
    let classification: Classification
    let metaInfo: MetaInfo
    let objectDetection: ObjectDetection
    let quality: Quality

    enum CodingKeys: String, CodingKey {
        case classification = "Classification"
        case metaInfo = "MetaInfo"
        case objectDetection = "ObjectDetection"
        case quality = "Quality"
    }
}
 // MARK: - Error
struct Error: Codable {
    let errorCode: Int
    let errorMsg: String

    enum CodingKeys: String, CodingKey{
        case errorCode = "ErrorCode"
        case errorMsg = "ErrorMsg"
    }
}

// MARK: - Classification
struct Classification: Codable {
    let labels, subLabel: [Label]

    enum CodingKeys: String, CodingKey {
        case labels = "Labels"
        case subLabel = "SubLabel"
    }
}

// MARK: - Label
struct Label: Codable {
    let id: Int
    let name: String
    let prob: Float

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case prob = "Prob"
    }
}

// MARK: - MetaInfo
struct MetaInfo: Codable {
    let apiVersion, dateTime: String
    let height: Int
    let imageContentURL: String
    let imageSourceType: String
    let sessionID, width: Int

    enum CodingKeys: String, CodingKey {
        case apiVersion = "APIVersion"
        case dateTime = "DateTime"
        case height = "Height"
        case imageContentURL = "ImageContentUrl"
        case imageSourceType = "ImageSourceType"
        case sessionID = "SessionId"
        case width = "Width"
    }
}

// MARK: - ObjectDetection
struct ObjectDetection: Codable {
    let metaTags: MetaTags
    let objects: [Object]

    enum CodingKeys: String, CodingKey {
        case metaTags = "MetaTags"
        case objects = "Objects"
    }
}

// MARK: - MetaTags
struct MetaTags: Codable {
    let bathAccessory, bathtub, decor, faucet: [String]?
    let flooring, lighting, shower, wallColor: [String?]?
    let window: [String]?

    enum CodingKeys: String, CodingKey {
        case bathAccessory = "bath-accessory"
        case bathtub, decor, faucet, flooring, lighting, shower
        case wallColor = "wall-color"
        case window
    }
}

// MARK: - Object
struct Object: Codable {
    let mainLabel: String
    let prob: Float
    let subLabels: [SubLabel]?
    let xmax, xmin, ymax, ymin: Int

    enum CodingKeys: String, CodingKey {
        case mainLabel = "MainLabel"
        case prob = "Prob"
        case subLabels = "SubLabels"
        case xmax = "Xmax"
        case xmin = "Xmin"
        case ymax = "Ymax"
        case ymin = "Ymin"
    }
}

// MARK: - SubLabel
struct SubLabel: Codable {
    let prob: Float
    let tag: String

    enum CodingKeys: String, CodingKey {
        case prob = "Prob"
        case tag = "Tag"
    }
}

// MARK: - Quality
struct Quality: Codable {
    let construction, isBlur, isLineDrawing: Bool
    let qualityScale: String
    let score: Float

    enum CodingKeys: String, CodingKey {
        case construction = "Construction"
        case isBlur = "IsBlur"
        case isLineDrawing = "IsLineDrawing"
        case qualityScale = "QualityScale"
        case score = "Score"
    }
}
