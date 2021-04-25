//
//  MarkPattern.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 17.12.20.
//

import Foundation

class DocumentPreferences: Identifiable, Codable{
    
    enum CodingKeys: String, CodingKey {
        case fontSize
        case showUnmarkedGray
        case caseInsensitive
        case firstPattern
        case secondPattern
        case thirdPattern
        case fourthPattern
        case fifthPattern
    }
    
    static var numPatterns : Int = 5
    
    var fontSize : Int = Preferences.defaultFontSize
    var showUnmarkedGray = false
    var caseInsensitive = true
    var patterns = [String](repeating: "",count: 5)
    
    var hasColorCoding : Bool{
        get{
            for i in 0..<DocumentPreferences.numPatterns{
                if !patterns[i].isEmpty{
                    return true
                }
            }
            return false
        }
    }
    
    func codingKey(idx: Int) -> CodingKeys{
        switch idx{
        case 0: return CodingKeys.firstPattern
        case 1: return CodingKeys.secondPattern
        case 2: return CodingKeys.thirdPattern
        case 3: return CodingKeys.fourthPattern
        case 4: return CodingKeys.fifthPattern
        default:
            fatalError("invalid coding key index")
        }
    }
    
    init(){
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fontSize = try values.decodeIfPresent(Int.self, forKey: .fontSize) ?? Preferences.defaultFontSize
        showUnmarkedGray = try values.decodeIfPresent(Bool.self, forKey: .showUnmarkedGray) ?? false
        caseInsensitive = try values.decodeIfPresent(Bool.self, forKey: .caseInsensitive) ?? true
        for i in 0..<DocumentPreferences.numPatterns{
            patterns[i] = try values.decodeIfPresent(String.self, forKey: codingKey(idx: i)) ?? ""
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fontSize, forKey: .fontSize)
        try container.encode(showUnmarkedGray, forKey: .showUnmarkedGray)
        try container.encode(caseInsensitive, forKey: .caseInsensitive)
        for i in 0..<DocumentPreferences.numPatterns{
            try container.encode(patterns[i], forKey: codingKey(idx: i))
        }
    }
    
    func reset(){
        fontSize = 12
        showUnmarkedGray = false
        caseInsensitive = true
        for i in 0..<DocumentPreferences.numPatterns{
            patterns[i] = ""
        }
    }
    
}
