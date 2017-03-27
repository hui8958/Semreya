//
//  GlobelData.swift
//  Semreya
//
//  Created by Hui on 2017-01-16.
//  Copyright © 2017 Hui. All rights reserved.
//

import Foundation
import os.log

class GlobelData{
    
    var persons:[Person] = [Person]()
    var setting:Setting = Setting(enableChina:true, enableSweden:true, enableDelivered:true, adminMode:false)!
    
    static let sharedInstance = GlobelData() // This is singleton
    
    private init() {
        print("MyClass Initialized")
          NotificationCenter.default.addObserver(self, selector: #selector(savePersons), name: NSNotification.Name(rawValue: "saveData"), object: nil)
        
        
        if let savedPersons = loadPersons() {
            persons += savedPersons
        }
        else {
            // Load the sample data.
            // LoadParcelFromDataBase()
            
        }
        if let savedSetting = loadSettings() {
            setting = savedSetting
        }
        else{
            setting = Setting(enableChina:true, enableSweden:true, enableDelivered:true,adminMode:false)!
        }
        
    }
    
    @objc func removeAllPersons(){
        self.persons.removeAll()
        savePersons()
    }
    
    @objc func savePersons(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self.persons, toFile: Person.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("persons successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save persons...", log: OSLog.default, type: .error)
        }
        
        
    }
    
    
    
    private func loadPersons() -> [Person]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Person.ArchiveURL.path) as? [Person]
        
        
        
    }
    
    
    func saveSettings(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject( self.setting, toFile: Setting.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("settings successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save Settings...", log: OSLog.default, type: .error)
        }
        
    }
    
    
    
    private func loadSettings() -> Setting? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Setting.ArchiveURL.path) as? Setting
        
        
        
    }
    
    
    
    
}
