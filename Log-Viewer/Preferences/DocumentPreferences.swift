//
//  MarkPattern.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 17.12.20.
//

import Foundation

class DocumentPreferences: Identifiable, Codable{
    
    enum CodingKeys: String, CodingKey {
        case fullLineColoring
        case patterns
    }
    
    //deprecated keys
    enum PatternCodingKeys: String, CodingKey{
        case firstPattern
        case secondPattern
        case thirdPattern
        case fourthPattern
        case fifthPattern
    }
    
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
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fullLineColoring = try values.decodeIfPresent(Bool.self, forKey: .fullLineColoring) ?? false
        patterns = try values.decodeIfPresent([String].self, forKey: .patterns) ?? [String]()
        if patterns.isEmpty{
            // deprecated storage
            let patternValues = try decoder.container(keyedBy: PatternCodingKeys.self)
            patterns = [String](repeating: "",count: Preferences.numPatterns)
            patterns[0] = try patternValues.decodeIfPresent(String.self, forKey: .firstPattern) ?? ""
            patterns[1] = try patternValues.decodeIfPresent(String.self, forKey: .secondPattern) ?? ""
            patterns[2] = try patternValues.decodeIfPresent(String.self, forKey: .thirdPattern) ?? ""
            patterns[3] = try patternValues.decodeIfPresent(String.self, forKey: .fourthPattern) ?? ""
            patterns[4] = try patternValues.decodeIfPresent(String.self, forKey: .fifthPattern) ?? ""
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fullLineColoring, forKey: .fullLineColoring)
        try container.encode(patterns, forKey: .patterns)
    }
    
    func reset(){
        for i in 0..<Preferences.numPatterns{
            patterns[i] = ""
        }
    }
    
}
