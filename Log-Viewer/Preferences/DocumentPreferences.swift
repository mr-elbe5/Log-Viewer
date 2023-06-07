/*
 Log-Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation

class DocumentPreferences: Identifiable, Codable{
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullLineColoring
        case skipUnmarked
        case patterns
    }
    
    var id : String
    var fullLineColoring = false
    var skipUnmarked = false
    var patterns = [String](repeating: "",count: GlobalPreferences.numPatterns)
    
    var hasColorCoding : Bool{
        get{
            for i in 0..<GlobalPreferences.numPatterns{
                if !patterns[i].isEmpty{
                    return true
                }
            }
            return false
        }
    }
    
    init(){
        id = String.generateRandomString(length: 16)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? String.generateRandomString(length: 16)
        fullLineColoring = try values.decodeIfPresent(Bool.self, forKey: .fullLineColoring) ?? false
        skipUnmarked = try values.decodeIfPresent(Bool.self, forKey: .skipUnmarked) ?? false
        patterns = try values.decodeIfPresent([String].self, forKey: .patterns) ?? [String](repeating: "",count: GlobalPreferences.numPatterns)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(fullLineColoring, forKey: .fullLineColoring)
        try container.encode(skipUnmarked, forKey: .skipUnmarked)
        try container.encode(patterns, forKey: .patterns)
    }
    
    func reset(){
        fullLineColoring = false
        skipUnmarked = false
        for i in 0..<GlobalPreferences.numPatterns{
            patterns[i] = ""
        }
    }
    
}
