//
//  TrackingInfo.swift
//  Semreya
//
//  Created by Hui on 2017-01-11.
//  Copyright © 2017 Hui. All rights reserved.
//

import UIKit


class TrackingInfo: NSObject,NSCoding{
    var time :String
    var location :String
    var type: String
    
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("TrackingInfo")
    
    struct PropertyKey {
        static let time = "time"
        static let location = "location"
        static let type = "type"
    }
    
    init(time: String, location: String, type:String) {
        self.time = time
        self.location = location
        self.type = type
        
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(time, forKey: PropertyKey.time)
        aCoder.encode(location, forKey: PropertyKey.location)
        aCoder.encode(type, forKey: PropertyKey.type)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let time = aDecoder.decodeObject(forKey: PropertyKey.time) as? String else {
                  return nil
        }
        let location = aDecoder.decodeObject(forKey: PropertyKey.location) as? String
          let type = aDecoder.decodeObject(forKey: PropertyKey.type) as? String
        
        // Must call designated initializer.
        self.init(time:time, location:location!, type:type!)
    }
    
    
}
