//
//  LogDocument.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 16.12.20.
//

import Foundation
import Cocoa

class LogDocument: NSDocument, PreferencesDelegate{
    
    var url : URL? = nil
    var preferences =  DocumentPreferences()
    
    var windowController : LogWindowController? = nil
    
    var viewController : LogViewController?{
        get{
            return windowController?.logViewController
        }
    }
    
    var chunks = [LogChunk]()
    
    private var fileHandle: FileHandle? = nil
    private var eventSource: DispatchSourceFileSystemObject? = nil

    deinit {
        releaseEventSource()
        fileHandle = nil
        url = nil
    }
    
    override class var autosavesInPlace: Bool {
        return false
    }
    
    override func makeWindowControllers() {
        windowController = LogWindowController(document: self)
        addWindowController(windowController!)
    }
    
    override func write(to url: URL, ofType typeName: String) throws {
        Swift.print("is write")
    }
    
    override func read(from url: URL, ofType typeName: String) throws {
        if FileManager.default.fileExists(atPath: url.path){
            do{
                preferences = Preferences.shared.getDocumentPreferences(url: url)
                fileHandle = try FileHandle(forReadingFrom: url)
                if let data = self.fileHandle?.readDataToEndOfFile(){
                    let chunk = LogChunk(String(data: data, encoding: .utf8) ?? "")
                    chunks.append(chunk)
                }
                setEventSource()
            }
            catch{
                Swift.print(error.localizedDescription)
            }
        }
    }
    
    func setEventSource(){
        if let fileHandle = self.fileHandle{
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
        if let data = self.fileHandle?.readDataToEndOfFile(){
            let chunk = LogChunk(String(data: data, encoding: .utf8) ?? "")
            chunks.append(chunk)
            viewController?.updateFromDocument()
        }
    }
    
    func savePreferences(){
        Preferences.shared.save()
    }

    func preferencesChanged(){
        viewController?.reset()
        for chunk in chunks{
            chunk.displayed = false
        }
        viewController?.updateFromDocument()
    }

    func markPatternChanged(){
        viewController?.reset()
        for chunk in chunks{
            chunk.displayed = false
        }
    }
      

}

