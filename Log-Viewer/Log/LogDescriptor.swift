/*
 Log-Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Cocoa

enum LogType: String{
    case file
    case remote
}

class LogDescriptor: NSObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case type
        case path
    }
    
    var type: LogType
    var path: String
    
    init(type: LogType, path: String){
        self.type = type
        self.path = path
    }
    
    init(type: LogType, url: URL){
        self.type = type
        self.path = url.path
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let s = try values.decodeIfPresent(String.self, forKey: .type){
            type =  LogType(rawValue: s) ?? .file
        }
        else{
            type = .file
        }
        path = try values.decodeIfPresent(String.self, forKey: .path) ?? ""
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type.rawValue, forKey: .type)
        try container.encode(path, forKey: .path)
    }
    
    func save(){
        let storeString = toJSON()
        UserDefaults.standard.set(storeString, forKey: "appState")
    }
    
}
