//
//  parcel.swift
//  Semreya
//
//  Created by Hui on 2017-01-11.
//  Copyright © 2017 Hui. All rights reserved.
//

import UIKit
import os.log

class Parcel: NSObject,NSCoding{
    
    //MARK: Properties
    
    var name: String
    var number: String
    var TrackingInfos = [TrackingInfo]()
    var state = 1
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("parcels")
    
    struct PropertyKey {
        static let name = "name"
        static let number = "number"
        static let TrackingInfos = "TrackingInfos"
        static let state = "state"
        
    }
    
    
    init?(name: String, number:String) {
        self.name = name
        self.number = number
        super.init()
        TrackingInfos.removeAll()
        
        if(GlobelData.sharedInstance.setting.enableChina){
             TrackingInfos += loadFromkuaidi100()
        }
       
        if(GlobelData.sharedInstance.setting.enableSweden){
            TrackingInfos += loadFromPostnord()
            
        }
        
    }
    func refreshData(){
        
         var TrackingInfosTemp = [TrackingInfo]()
        
        if(GlobelData.sharedInstance.setting.enableChina){
            TrackingInfosTemp += loadFromkuaidi100()
        }
        
        if(GlobelData.sharedInstance.setting.enableSweden){
           TrackingInfosTemp +=  loadFromPostnord()
            
        }
        TrackingInfos = TrackingInfosTemp
NotificationCenter.default.post(name: NSNotification.Name(rawValue: "saveData"), object: nil)
        
    }
    
    func loadFromPostnord() -> [TrackingInfo]{
        
        var TrackingInfosPostNord = [TrackingInfo]()
        
        typealias JSONDictionary = [String: AnyObject]
        
        typealias JSONArray = Array<AnyObject>
        
        let url = Foundation.URL(string: "https://api2.postnord.com/rest/shipment/v1/trackandtrace/findByIdentifier.json?id=\(number)&locale=en&apikey=8cacde88fa91a4300da2d17739d36a2f")
        do {
            let data = try Data(contentsOf: url!)
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! JSONDictionary
            if let TrackingInformationResponse = json["TrackingInformationResponse"] as? JSONDictionary{
                if let shipments = TrackingInformationResponse["shipments"] as? JSONArray {
                    if let items1 = shipments[0] as? JSONDictionary{
                        if let items  = items1["items"] as?JSONArray{
                            if let item2 = items[0] as? JSONDictionary{
                                if let events = item2["events"] as?JSONArray{
                                    for (_, event) in events.enumerated() .reversed() {
                                        
                                        
                                        
                                        let eventDescription =  event["eventDescription"] as! String
                                        var eventTime =  event["eventTime"] as! String
                                        eventTime = eventTime.replacingOccurrences(of: "T", with: " ")
                                        var location = ""
                                        if let locations = event["location"] as? JSONDictionary{
                                            if let city = locations["city"] as? String{
                                                location = "[" + city + "] " + eventDescription
                                                
                                            }else{
                                                location = eventDescription
                                            }
                                        }
                                        
                                        TrackingInfosPostNord.append(TrackingInfo.init(time: eventTime, location: location, type:"SE"))
                                        
                                    }
                                    
                                    
                                }
                                
                            }
                            
                            
                        }
                    }
                }
                                
            }
               print("Successfully receive from Postnord")
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        
        return TrackingInfosPostNord;
        
    }
    
    func loadFromkuaidi100()-> [TrackingInfo]{
        
        var TrackingInfosKuaidi100 = [TrackingInfo]()
        
        let url=URL(string:"http://www.kuaidi100.com/query?type=ems&postid="+number)
        do {
            let allContactsData = try Data(contentsOf: url!)
            let allContacts = try JSONSerialization.jsonObject(with: allContactsData, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : AnyObject]
            
            let numLikesUnsigned = (allContacts["state"]?.integerValue).map { UInt($0) }
            // print(numLikesUnsigned)
            self.state = Int(numLikesUnsigned!)
            if let arrJSON = allContacts["data"] {
                for object in arrJSON as! [[String: AnyObject]] {
                    let time = object["time"] as! String
                    let location = object["context"] as! String
                     let sublocation = location.components(separatedBy: "】")
                    
                    let info = sublocation[0] + "】" + sublocation[2]
                    if(info.contains("马尔默")){
                        TrackingInfosKuaidi100.append(TrackingInfo.init(time: time, location: info, type:"SE"))

                    }else{
                        TrackingInfosKuaidi100.append(TrackingInfo.init(time: time, location: info, type:"CN"))

                    }
                    
                }
                print("Successfully receive from Kuaidi100")
            }else{
                 TrackingInfosKuaidi100.append(TrackingInfo.init(time:"", location: "暂无国内段信息", type:"CN"))
            }
            
        }catch {
            
        }
        return TrackingInfosKuaidi100
        
    }
    
    init?(name:String, number:String, TrackingInfos:[TrackingInfo],state:Int){
        self.name = name
        self.number = number
        self.TrackingInfos = TrackingInfos
        self.state=state
    }
    
    func lastTracingInfo() 	-> String{
        
        
        
        return TrackingInfos[0].location
        
    }
    func lastTracingTimeInfo() 	-> String{
        
        
        return TrackingInfos[0].time
        
    }
    
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(number, forKey: PropertyKey.number)
        aCoder.encode(TrackingInfos, forKey: PropertyKey.TrackingInfos)
        aCoder.encode(state, forKey: PropertyKey.state)
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        let number = aDecoder.decodeObject(forKey: PropertyKey.number) as? String
        let TrackingInfos = aDecoder.decodeObject(forKey: PropertyKey.TrackingInfos)
        let state = aDecoder.decodeInteger(forKey: PropertyKey.state)
        
        // Must call designated initializer.
        self.init(name:name, number:number!, TrackingInfos:TrackingInfos as! [TrackingInfo],state:state)
    }
    
}
