/*
 SwiftyStringExtensions
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation

extension StringProtocol{

    func indexOf(_ str: String) -> String.Index? {
        self.range(of: str, options: .literal)?.lowerBound
    }

    func lastIndexOf(_ str: String) -> String.Index? {
        self.range(of: str, options: .backwards)?.lowerBound
    }

    func index(of string: String, from: Index) -> Index? {
        range(of: string, options: [], range: from..<endIndex, locale: nil)?.lowerBound
    }

    func charAt(_ i: Int) -> Character{
        let idx = self.index(startIndex, offsetBy: i)
        return self[idx]
    }

    func substr(_ from: Int,_ to:Int, includeLast : Bool = false) -> String{
        if to + (includeLast ? 1 : 0) < from{
            return ""
        }
        let start = self.index(startIndex, offsetBy: from)
        let end = self.index(start, offsetBy: to - from)
        return includeLast ? String(self[start...end]) : String(self[start..<end])
    }

    func trim() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func unquote() -> String {
        trimmingCharacters(in: ["\""])
    }

    // tag format extensions

    func toHtml() -> String {
        var result = ""
        for ch in self {
            switch ch {
            case "\"": result.append("&quot;")
            case "'": result.append("&apos;")
            case "&": result.append("&amp;")
            case "<": result.append("&lt;")
            case ">": result.append("&gt;")
            default: result.append(ch)
            }
        }
        return result
    }

    func toHtmlMultiline() -> String {
        toHtml().replacingOccurrences(of: "\n", with: "<br/>\n")
    }

    func toUri() -> String {
        var result = ""
        var code = ""
        for ch in self {
            switch ch{
            case "$" : code = "%24"
            case "&" : code = "%26"
            case ":" : code = "%3A"
            case ";" : code = "%3B"
            case "=" : code = "%3D"
            case "?" : code = "%3F"
            case "@" : code = "%40"
            case " " : code = "%20"
            case "\"" : code = "%5C"
            case "<" : code = "%3C"
            case ">" : code = "%3E"
            case "#" : code = "%23"
            case "%" : code = "%25"
            case "~" : code = "%7E"
            case "|" : code = "%7C"
            case "^" : code = "%5E"
            case "[" : code = "%5B"
            case "]" : code = "%5D"
            default: code = ""
            }
            if !code.isEmpty {
                result.append(code)
            }
            else{
                result.append(ch)
            }
        }
        return result
    }

    func toXml() -> String {
        var result = ""
        for ch in self {
            switch ch {
            case "\"": result.append("&quot;")
            case "'": result.append("&apos;")
            case "&": result.append("&amp;")
            case "<": result.append("&lt;")
            case ">": result.append("&gt;")
            default: result.append(ch)
            }
        }
        return result
    }

    // parsing

    // replace placeholders in braces like {{test}} or {{_test}} (localized html)

    func replacePlaceholders(language: String, _ params: [String: String]?) -> String {
        var s = ""
        var p1: String.Index = startIndex
        var p2: String.Index
        while true {
            if var varStart = index(of: "{{", from: p1) {
                p2 = varStart
                s.append(String(self[p1..<p2]))
                varStart = self.index(varStart, offsetBy: 2)
                if let varEnd = index(of: "}}", from: varStart) {
                    let key = String(self[varStart..<varEnd])
                    if key.contains("{{") {
                        p1 = p2
                        print("parse error before \(varEnd)")
                        break
                    }
                    if key.hasPrefix("_") {
                        s.append(key.toLocalizedHtml(language: language))
                    } else if let value = params![key] {
                        s.append(value)
                    }
                    p1 = self.index(varEnd, offsetBy: 2)
                } else {
                    p1 = p2
                    print("parse error at \(varStart)")
                    break
                }
            } else {
                break
            }
        }
        s.append(String(self[p1..<endIndex]))
        return s
    }

    func getKeyValueDict() -> [String: String] {
        var attr = [String: String]()
        var s = ""
        var key = ""
        var quoted = false
        for ch in self {
            switch ch {
            case "\"":
                if quoted {
                    if !key.isEmpty {
                        attr[key] = s
                        key = ""
                        s = ""
                    }
                }
                quoted = !quoted
            case "=":
                key = s
                s = ""
            case " ":
                if quoted {
                    fallthrough
                }
            default:
                s.append(ch)
            }
        }
        return attr
    }

}
