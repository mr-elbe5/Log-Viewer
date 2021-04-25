//
//  Codable.swift
//  tomcatctrl
//
//  Created by Michael Rönnau on 30.11.20.
//

import Foundation

import Foundation

extension Decodable{
    static func deserialize<T: Decodable>(encoded : String) -> T?{
        if let data = Data(base64Encoded: encoded){
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try? decoder.decode(T.self, from : data)
        }
        return nil
    }
    
    static func fromJSON<T: Decodable>(encoded : String) -> T?{
        if let data =  encoded.data(using: .utf8){
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try? decoder.decode(T.self, from : data)
        }
        return nil
    }
    
}

extension Encodable{
    func serialize() -> String{
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        if let json = try? encoder.encode(self).base64EncodedString(){
            return json
        }
        return ""
    }
    
    func toJSON() -> String{
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        if let data = try? encoder.encode(self){
            if let s = String(data:data, encoding: .utf8){
                return s
            }
        }
        return ""
    }
    
}
