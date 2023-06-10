/*
 Log-Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation
import Cocoa

class LogFileDocument: LogDocument{
    
    private var fileHandle: FileHandle? = nil
    private var eventSource: DispatchSourceFileSystemObject? = nil
    
    override func releaseLogSource(){
        releaseEventSource()
        fileHandle = nil
    }
    
    func read(from url: URL, ofType typeName: String) throws {
        if FileManager.default.fileExists(atPath: url.path){
            do{
                preferences = GlobalPreferences.shared.getDocumentPreferences(url: url)
                fileHandle = try FileHandle(forReadingFrom: url)
                Log.debug("start read")
                if GlobalPreferences.shared.showFullFile, let data = fileHandle?.readDataToEndOfFile(){
                    let str = String(data: data, encoding: .utf8) ?? ""
                    if GlobalPreferences.shared.maxLines != 0{
                        chunks.append(LogChunk(str.substr(lines: GlobalPreferences.shared.maxLines)))
                    }
                    else{
                        chunks.append(LogChunk(str))
                    }
                }
                setEventSource()
            }
            catch{
                Swift.print(error.localizedDescription)
            }
        }
    }
    
    func setEventSource(){
        if let fileHandle = fileHandle{
            let eventSource = DispatchSource.makeFileSystemObjectSource(
                fileDescriptor: fileHandle.fileDescriptor,
                eventMask: .extend,
                queue: DispatchQueue.main
            )
            eventSource.setEventHandler {
                let event = eventSource.data
                self.processEvent(event: event)
            }
            eventSource.setCancelHandler {
                if #available(macOS 10.15, *){
                    try? fileHandle.close()
                }
                else{
                    fileHandle.closeFile()
                }
            }
            fileHandle.seekToEndOfFile()
            eventSource.resume()
            self.eventSource = eventSource
        }
    }
    
    func releaseEventSource(){
        eventSource?.cancel()
        eventSource = nil
    }
    
    func processEvent(event: DispatchSource.FileSystemEvent) {
        guard event.contains(.extend) else {
            return
        }
        if let data = fileHandle?.readDataToEndOfFile(){
            let chunk = LogChunk(String(data: data, encoding: .utf8) ?? "")
            chunks.append(chunk)
            viewController?.updateFromDocument()
        }
    }
      
}

