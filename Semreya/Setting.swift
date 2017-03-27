//
//  Settings.swift
//  Semreya
//
//  Created by Hui on 2017-01-17.
//  Copyright © 2017 Hui. All rights reserved.
//

import Foundation
import os.log

class Setting: NSObject,NSCoding{
    
    var enableChina = true
    var enableSweden = true
    var enableDelivered = true
    var adminMode = false

    
    struct PropertyKey {
        static let enableChina = "enableChina"
        static let enableSweden = "enableSweden"
        static let enableDelivered = "enableDelivered"
        static let adminMode = "adminMode"
        
        
        
    }
    init?(enableChina:Bool,enableSweden:Bool,enableDelivered:Bool, adminMode:Bool){
    
        self.enableChina = enableChina
        self.enableSweden = enableSweden
        self.enableDelivered = enableDelivered
        self.adminMode = adminMode
        
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("settings")
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(enableChina, forKey: PropertyKey.enableChina)
        aCoder.encode(enableSweden, forKey: PropertyKey.enableSweden)
        aCoder.encode(enableDelivered, forKey: PropertyKey.enableDelivered)
        aCoder.encode(adminMode, forKey:PropertyKey.adminMode)
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
         let enableChina = aDecoder.decodeBool(forKey: PropertyKey.enableChina)
        let enableSweden = aDecoder.decodeBool(forKey: PropertyKey.enableSweden)
        let enableDelivered = aDecoder.decodeBool(forKey: PropertyKey.enableDelivered)
        let adminMode = aDecoder.decodeBool(forKey: PropertyKey.adminMode)
        
        // Must call designated initializer.
        self.init(enableChina:enableChina, enableSweden : enableSweden, enableDelivered:enableDelivered, adminMode:adminMode)
    }
    
    
}
