//
//  MarkPattern.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 17.12.20.
//

import Foundation

class DocumentPreferences: Identifiable, Codable{
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullLineColoring
        case patterns
    }
    
    var id : String
    var fullLineColoring = false
    var patterns = [String](repeating: "",count: Preferences.numPatterns)
    
    var hasColorCoding : Bool{
        get{
            for i in 0..<Preferences.numPatterns{
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
        patterns = try values.decodeIfPresent([String].self, forKey: .patterns) ?? [String](repeating: "",count: Preferences.numPatterns)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(fullLineColoring, forKey: .fullLineColoring)
        try container.encode(patterns, forKey: .patterns)
    }
    
    func reset(){
        for i in 0..<Preferences.numPatterns{
            patterns[i] = ""
        }
    }
    
}
