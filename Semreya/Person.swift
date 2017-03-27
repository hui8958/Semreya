//
//  Person.swift
//  Semreya
//
//  Created by Hui on 2017-01-15.
//  Copyright © 2017 Hui. All rights reserved.
//

import UIKit
import os.log

class Person: NSObject,NSCoding{
    
    //MARK: Properties
    var personName: String
    var parcels  = [Parcel]()
    
    
    init?(name: String) {
        self.personName = name
        super.init()
        addParcel(PersonName: name)
        
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("persons")
    
    struct PropertyKey {
        static let personName = "personName"
        static let parcels = "parcels"

        
    }
    
    init?(name:String, parcels:[Parcel]){
        self.personName = name
        self.parcels = parcels
    }

    
    
   
    func addParcel(PersonName:String){
        
        let url = Foundation.URL(string:"http://hh-ss.se/webshop/service.php")
        do{
                self.parcels.removeAll()
            let data = try Data(contentsOf: url!)
            
            let dataString = String(data: data, encoding: String.Encoding.utf8) as String!
            
            var commaSeparatedArray =  dataString!.components(separatedBy: ";")
            
            commaSeparatedArray.removeLast()
            
            for parcel in commaSeparatedArray{
                
                
                var stringArray = parcel.components(separatedBy: ", ")
                let name = stringArray[1].components(separatedBy: ": ")[1]
                let trackingnumber = stringArray[0].components(separatedBy: ": ")[1]
                if(name == PersonName){
                    parcels.append(Parcel(name:name, number:trackingnumber)!)
                    
                }
                
            }
            
            
        }catch{
            
        }

        
        
        /*
        
        typealias JSONDictionary = [String: AnyObject]
        
        typealias JSONArray = Array<AnyObject>
        
        let url = Foundation.URL(string: "https://spreadsheets.google.com/feeds/list/1V3Pap91laxnT3FvxvTMNMVsy0M0mq014EyDQf6hqAyI/1/public/basic?alt=json")
        do {
            let data = try Data(contentsOf: url!)
            
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! JSONDictionary
            
            if let feed = json["feed"] as? JSONDictionary,let entries = feed["entry"] as? JSONArray {
                self.parcels.removeAll()
                for (_, entry) in entries.enumerated() {
                    
                    if let name = entry["content"] as? JSONDictionary{
                        
                        if let tracing =  name["$t"] as? String{
                            var commaSeparatedArray = tracing.components(separatedBy: ", ")
                            
                            let subcommaSeparatedArray1 = commaSeparatedArray[0].components(separatedBy: ": ")
                            let subcommaSeparatedArray2 = commaSeparatedArray[1].components(separatedBy: ": ")
                            let trackingnumber = subcommaSeparatedArray1[1]
                            let name = subcommaSeparatedArray2[1]
                            
                            if(name == PersonName){
                                parcels.append(Parcel(name:name, number:trackingnumber)!)
                                
                            }
                        }
                    }
                }
            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }

        */
        
        
        
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(personName, forKey: PropertyKey.personName)
        aCoder.encode(parcels, forKey: PropertyKey.parcels)
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let personName = aDecoder.decodeObject(forKey: PropertyKey.personName) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        let parcels = aDecoder.decodeObject(forKey: PropertyKey.parcels)
        
        // Must call designated initializer.
        self.init(name:personName, parcels : parcels as! [Parcel])
    }
    
}
