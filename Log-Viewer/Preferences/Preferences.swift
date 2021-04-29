//
//  Preferences.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 09.12.20.
//

import Foundation
import SwiftyDataExtensions
import SwiftyMacViewExtensions

protocol PreferencesDelegate {
    func preferencesChanged()
}

class Preferences: Identifiable, Codable{
    
    static var shared = Preferences()
    
    static var fontSizes = [10, 12, 14, 16, 18, 20, 24]
    static var numPatterns : Int = 5
    
    static var defaultTextColorSet : [CodableColor] = [
        CodableColor(red: 0, green: 0, blue: 0),
        CodableColor(red: 0, green: 0, blue: 0),
        CodableColor(red: 0, green: 0, blue: 0),
        CodableColor(red: 0, green: 0, blue: 0),
        CodableColor(red: 0, green: 0, blue: 0)
    ]
    
    static var darkmodeTextColorSet : [CodableColor] = [
        CodableColor(red: 1, green: 1, blue: 0.35), // yellow
        CodableColor(red: 1, green: 0.8, blue: 0.6), // orange
        CodableColor(red: 0.6, green: 1, blue: 0.5), //green
        CodableColor(red: 0.5, green: 1, blue: 1), //cyan
        CodableColor(red: 0.9, green: 0.7, blue: 1) //purple
    ]
    
    static var defaultBackgroundColorSet : [CodableColor] = [
        CodableColor(red: 1, green: 1, blue: 0.35), // yellow]
        CodableColor(red: 1, green: 0.8, blue: 0.6), // orange
        CodableColor(red: 0.6, green: 1, blue: 0.5), //green
        CodableColor(red: 0.5, green: 1, blue: 1), //cyan
        CodableColor(red: 0.9, green: 0.7, blue: 1) //purple
    ]
    
    static var darkmodeBackgroundColorSet : [CodableColor] = [
        CodableColor(red: 0, green: 0, blue: 0),
        CodableColor(red: 0, green: 0, blue: 0),
        CodableColor(red: 0, green: 0, blue: 0),
        CodableColor(red: 0, green: 0, blue: 0),
        CodableColor(red: 0, green: 0, blue: 0)
    ]
    
    enum CodingKeys: String, CodingKey {
        case showSplash
        case rememberWindowFrame
        case fontSize
        case showUnmarkedGray
        case caseInsensitive
        case textColors
        case backgroundColors
        case documentPreferences
    }
    
    var showSplash = true
    var rememberWindowFrame = true
    var fontSize = 14
    var showUnmarkedGray = true
    var caseInsensitive = true
    var textColors : [CodableColor] = Statics.isDarkMode ? darkmodeTextColorSet : defaultTextColorSet
    var backgroundColors : [CodableColor] = Statics.isDarkMode ? darkmodeBackgroundColorSet : defaultBackgroundColorSet
    var documentPreferences = [URL: DocumentPreferences]()
    
    init(){
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        showSplash = try values.decodeIfPresent(Bool.self, forKey: .showSplash) ?? true
        rememberWindowFrame = try values.decodeIfPresent(Bool.self, forKey: .rememberWindowFrame) ?? true
        fontSize = try values.decodeIfPresent(Int.self, forKey: .fontSize) ?? 14
        showUnmarkedGray = try values.decodeIfPresent(Bool.self, forKey: .showUnmarkedGray) ?? true
        caseInsensitive = try values.decodeIfPresent(Bool.self, forKey: .caseInsensitive) ?? true
        textColors = try values.decodeIfPresent([CodableColor].self, forKey: .textColors) ?? (Statics.isDarkMode ? Preferences.darkmodeTextColorSet : Preferences.defaultTextColorSet)
        backgroundColors = try values.decodeIfPresent([CodableColor].self, forKey: .backgroundColors) ?? (Statics.isDarkMode ? Preferences.darkmodeBackgroundColorSet : Preferences.defaultBackgroundColorSet)
        documentPreferences = try values.decodeIfPresent([URL: DocumentPreferences].self, forKey: .documentPreferences) ?? [URL: DocumentPreferences]()
        save()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(showSplash, forKey: .showSplash)
        try container.encode(rememberWindowFrame, forKey: .rememberWindowFrame)
        try container.encode(fontSize, forKey: .fontSize)
        try container.encode(showUnmarkedGray, forKey: .showUnmarkedGray)
        try container.encode(caseInsensitive, forKey: .caseInsensitive)
        try container.encode(textColors, forKey: .textColors)
        try container.encode(backgroundColors, forKey: .backgroundColors)
        try container.encode(documentPreferences, forKey: .documentPreferences)
    }
    
    func resetGlobalSettings(){
        showSplash = true
        rememberWindowFrame = true
        fontSize = 14
        showUnmarkedGray = false
        caseInsensitive = true
        textColors = Statics.isDarkMode ? Preferences.darkmodeTextColorSet : Preferences.defaultTextColorSet
        backgroundColors = Statics.isDarkMode ? Preferences.darkmodeBackgroundColorSet : Preferences.defaultBackgroundColorSet
    }
    
    func resetDocumentPreferences(){
        documentPreferences.removeAll()
    }
    
    func getDocumentPreferences(url: URL) -> DocumentPreferences{
        if documentPreferences.keys.contains(url){
            return documentPreferences[url]!
        }
        let prefs = DocumentPreferences()
        documentPreferences[url] = prefs
        save()
        return prefs
    }
    
    static func load(){
        if let storedString = UserDefaults.standard.value(forKey: "logPreferences") as? String {
            if let history : Preferences = Preferences.fromJSON(encoded: storedString){
                Preferences.shared = history
            }
        }
        else{
            print("no saved data available for preferences")
            Preferences.shared = Preferences()
        }
    }
    
    func save(){
        let storeString = self.toJSON()
        UserDefaults.standard.set(storeString, forKey: "logPreferences")
    }
}


