/*
 Log-Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation
import Cocoa

class RemoteLogFile: LogFile{
    
    var sshServer: String
    var sshPort: Int
    var sshUser: String
    var path: String
    
    init(server: String, port: Int = 22, user: String, path: String){
        self.sshServer = server
        self.sshPort = port
        self.sshUser = user
        self.path = path
        super.init()
    }
    
    override func releaseLogSource(){
        
    }
      
}

