//
//  Preferences.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 09.12.20.
//

import Foundation
import SwiftyDataExtensions
import Cocoa

protocol PreferencesDelegate {
    func preferencesChanged()
}

class Preferences: Identifiable, Codable{
    
    static var shared = Preferences()
    
    static var fontSizes = [10, 12, 14, 16, 18, 20, 24]
    
    static var defaultFontSize = 14
    
    static var colors = [
        NSColor(srgbRed: 1, green: 1, blue: 0.35, alpha: 1), // yellow]
        NSColor(srgbRed: 1, green: 0.8, blue: 0.6, alpha: 1), // orange
        NSColor(srgbRed: 0.6, green: 1, blue: 0.5, alpha: 1), //green
        NSColor(srgbRed: 0.5, green: 1, blue: 1, alpha: 1), //cyan
        NSColor(srgbRed: 0.9, green: 0.7, blue: 1, alpha: 1) //purple
    ]
    
    enum CodingKeys: String, CodingKey {
        case documentPreferences
    }
    
    var documentPreferences = [URL: DocumentPreferences]()
    
    init(){
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        documentPreferences = try values.decodeIfPresent([URL: DocumentPreferences].self, forKey: .documentPreferences) ?? [URL: DocumentPreferences]()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(documentPreferences, forKey: .documentPreferences)
    }
    
    func reset(){
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


