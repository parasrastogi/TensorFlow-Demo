//
//  DataCoader.swift
//  TenserFlow Demo
//
//  Created by Paras Rastogi on 04/01/21.
//

import UIKit

struct DataCoder {

    private static var _serverDateFormatter: DateFormatter?
    static func serverDateFormatter() -> DateFormatter? {
        if _serverDateFormatter == nil {
            _serverDateFormatter = DateFormatter()
            _serverDateFormatter?.dateFormat = "yyyy-MM-dd"
        }
        return _serverDateFormatter
    }
    
    /// Encode with Model
    static func encode<T>(_ object: T) throws -> [String: Any]? where T: Codable {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(object)
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            guard let params = json as? [String: Any] else {
                return nil
            }
            return params
        } catch let error {
            throw error
        }
    }
    
    /// Encode JSON with Model
    static func encodeJSON<T>(_ object: T) throws -> [String: Any]? where T: Encodable {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(object)
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            guard let params = json as? [String: Any] else {
                return nil
            }
            return params
        } catch let error {
            throw error
        }
    }
    
    /// Decode from Data
    static func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Codable {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(type, from: data)
        } catch let error {
            throw error
        }
    }
    
    /// Decode from JSON
    static func decode<T>(_ type: T.Type, from json: String) throws -> T where T: Codable {
        do {
            let data = Data(json.utf8)
            return try decode(type, from: data)
        } catch let error {
            throw error
        }
    }
    
    /// Decode from Dictionary
    static func decode<T>(_ type: T.Type, from json: [String: Any]) throws -> T where T: Codable {
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            return try decode(type, from: data)
        } catch let error {
            throw error
        }
    }

}

extension Encodable {
    
    /// Encode to JSON
    func toJSON() -> [String: Any]? {
        do {
        let value = try DataCoder.encodeJSON(self)
            return value
        } catch {
            return nil
        }
    }
    
    /// Decode from Data to Model
    func toModel<T>(_ type: T.Type, from data: Data) throws -> T where T: Codable {
        do {
            return try DataCoder.decode(type, from: data)
        } catch {
            throw error
        }
    }
    
    /// Serialize to JSON
    func toJSONString() -> String? {
        do {
            let value = try DataCoder.encodeJSON(self)
            let data = try JSONSerialization.data(withJSONObject: value!, options: JSONSerialization.WritingOptions.prettyPrinted)
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
}
