/*
 Log-Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation

struct StringLocalizer{

    private static var bundles = Dictionary<String, Bundle>()

    static func initialize(languages: Array<String>, bundleLocation: String) -> Bool{
        var success = true
        for lang in languages{
            let path = bundleLocation.appendPath(lang + ".lproj")
            if let bundle = Bundle(path: path){
                bundles[lang] = bundle
            }
            else{
                success = false
            }
        }
        return success
    }

    static func localize(src: String) -> String{
        NSLocalizedString(src, comment: "")
    }

    static func localize(src: String, language: String, def: String? = nil) -> String{
        if let bundle = bundles[language]{
            return bundle.localizedString(forKey: src, value: def, table: nil)
        }
        if let bundle = bundles["en"]{
            return bundle.localizedString(forKey: src, value: def, table: nil)
        }
        return src
    }

}
