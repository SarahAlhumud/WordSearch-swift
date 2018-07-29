//
//  JsonGen.swift
//
//  Json encoders and decoders for some base Swift and Foundation types.
//  Part of the swift-json-gen project
//  https://github.com/tomlokhorst/swift-json-gen/blob/develop/example/JsonGen.swift
//

import Foundation

typealias AnyJson = AnyObject
typealias JsonObject = [String: AnyJson]
typealias JsonArray = [AnyJson]

extension String {
    static func decodeJson(_ json: AnyObject) -> String? {
        return json as? String
    }

    func encodeJson() -> String {
        return self
    }
}

extension Bool {
    static func decodeJson(_ json: AnyObject) -> Bool? {
        return json as? Bool
    }

    func encodeJson() -> Bool {
        return self
    }
}

extension Int {
    static func decodeJson(_ json: AnyObject) -> Int? {
        return json as? Int
    }

    func encodeJson() -> Int {
        return self
    }
}

extension UInt {
    static func decodeJson(_ json: AnyObject) -> UInt? {
        return json as? UInt
    }

    func encodeJson() -> UInt {
        return self
    }
}

extension Int64 {
    static func decodeJson(_ json: AnyObject) -> Int64? {
        let number = json as? NSNumber
        return number.map { $0.int64Value }
    }

    func encodeJson() -> NSNumber {
        return NSNumber(value: self as Int64)
    }
}

extension Float {
    static func decodeJson(_ json : AnyObject) -> Float? {
        let number = json as? NSNumber
        return number.map { $0.floatValue }
    }

    func encodeJson() -> Float {
        return self
    }
}

extension Double {
    static func decodeJson(_ json : AnyObject) -> Double? {
        let number = json as? NSNumber
        return number.map { $0.doubleValue }
    }

    func encodeJson() -> Double {
        return self
    }
}

extension NSDictionary {
    class func decodeJson(_ json: AnyObject) -> NSDictionary? {
        return json as? NSDictionary
    }

    func encodeJson() -> NSDictionary {
        return self
    }
}

extension URL {
    static func decodeJson(_ json: AnyObject) -> URL? {
        if let str = json as? String {
            return URL(string: str)
        }

        return nil
    }

    func encodeJson() -> NSObject {
        return self.absoluteString as NSObject? ?? NSNull()
    }
}

extension Date
{
    struct JsonGenDateFormatter {
        static let withTimeZone : DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

            return formatter
        }()
    }

    static func decodeJson(_ json : AnyObject) -> Date? {
        if let dateString = json as? String {
            return JsonGenDateFormatter.withTimeZone.date(from: dateString)
        }

        return nil
    }

    func encodeJson() -> String {
        return JsonGenDateFormatter.withTimeZone.string(from: self)
    }
}

extension Optional {
    static func decodeJson(_ decodeWrapped: (AnyObject) -> Wrapped?, _ json: AnyObject) -> Wrapped? {
        return decodeWrapped(json)
    }

    func encodeJson(_ encodeJsonWrapped: (Wrapped) -> AnyObject) -> AnyObject {
        return self.map(encodeJsonWrapped) ?? NSNull()
    }
}

extension Array {
    static func decodeJson(_ decodeElement: (AnyObject) -> Element?, _ json: AnyObject) -> [Element]? {
        if let arr = json as? [AnyObject] {
            let decoded = arr.map(decodeElement)

            if decoded.filter({ $0 == nil }).first != nil {
                return nil
            }

            return decoded.map { $0! }
        }

        return nil
    }

    func encodeJson(_ encodeJsonElement: (Element) -> AnyObject) -> [AnyObject] {
        return self.map(encodeJsonElement)
    }
}

extension Dictionary {
    static func decodeJson(_ decodeKey: (AnyObject) -> Key?, _ decodeValue: (AnyObject) -> Value?, _ json: AnyObject) -> [Key: Value]? {
        var result: [Key: Value] = [:]

        if let dict = json as? [Key: AnyObject] {
            for (key, val) in dict {
                if let value = decodeValue(val) {
                    result[key] = value
                }
                else {
                    return nil
                }
            }
        }
        
        return result
    }
    
    func encodeJson(_ encodeJsonKey: (Key) -> String, _ encodeJsonValue: (Value) -> AnyObject) -> [String: AnyObject] {
        var dict: [String: AnyObject] = [:]
        
        for (key, val) in self {
            let keyString = encodeJsonKey(key)
            dict[keyString] = encodeJsonValue(val)
        }
        
        for (key, value) in self {
            dict[encodeJsonKey(key)] = encodeJsonValue(value)
        }
        
        return dict
    }
}
