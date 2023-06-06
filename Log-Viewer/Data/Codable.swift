/*
 Log-Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

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
