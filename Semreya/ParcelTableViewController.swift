//
//  ParcelTableViewController.swift
//  Semreya
//
//  Created by Hui on 2017-01-11.
//  Copyright © 2017 Hui. All rights reserved.
//

import UIKit
import os.log
import AVFoundation


class ParcelTableViewController: UITableViewController {
    
    var persons = [Person]()
    @IBOutlet var table: UITableView!
    var player: AVAudioPlayer?
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        
        self.refreshControl!.addTarget(self, action: #selector(refreshData),
                                       for: .valueChanged)
        self.refreshControl!.attributedTitle = NSAttributedString(string: "稍等一下马上就来咯😘")
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(rawValue: "reloadTableview"), object: nil)


        persons = GlobelData.sharedInstance.persons
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func addPerson(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "添加收件人", message: "请输入收件人姓名", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "确认", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                // store your data
                print("begin refreshing")
                
                
                self.table.setContentOffset(CGPoint(x: 0, y: 0-(self.refreshControl!.frame.size.height)), animated: true)
                if(self.NameIsExsist(nameCheck: field.text!) || field.text == "朗倩倩"){
                    self.refreshControl!.beginRefreshing()
                    self.addAllPerson(name: field.text!)
                }else{
                    var text : String = "找不到你输入的名字，要不要再试试？"
                    if(field.text == "吴彦祖"){
                        text = "呵呵，请不要开玩笑...."
                    }
                    let alert = UIAlertController(title: "Oooops...", message: text, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "好的", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }
                print("taped ok with " + field.text!)
                
            } else {
                // user did not fill field
            }
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in }
        
        
        alertController.addTextField { (textField) in
            textField.placeholder = "例如：吴彦祖"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func addAllPerson(name: String){
        
        let serialQueue = DispatchQueue(label: "com.queue.Serial")
        serialQueue.async {
            
            if(name == "朗倩倩"){
                GlobelData.sharedInstance.removeAllPersons()
                for name in self.getNamesFromDataBase() {
                    GlobelData.sharedInstance.persons.append(Person(name:name)!)
                    
                }
                
            }else if(self.NameIsExsistInPerson(nameCheck: name)){
                
                for (index,person) in GlobelData.sharedInstance.persons.enumerated(){
                    if(person.personName==name){
                        GlobelData.sharedInstance.persons.remove(at: index)
                        GlobelData.sharedInstance.persons.append(Person(name: name)!)
                    }
                    
                }
            }else{
                
                GlobelData.sharedInstance.persons.append(Person(name: name)!)
                
            }
            self.persons = GlobelData.sharedInstance.persons
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "saveData"), object: nil)
            
            self.tableView.reloadData()
            self.tableView.setNeedsDisplay()
            self.refreshControl!.endRefreshing()
        }
        
        
    }
    
    func playSound() {
        let url = Bundle.main.url(forResource: "Ding", withExtension: "wav")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func reloadData(){
        print("receive Notice")
        
        persons = GlobelData.sharedInstance.persons
        self.tableView.reloadData()
        self.tableView.setNeedsDisplay()
    }
    
    func refreshData(){
        let serialQueue = DispatchQueue(label: "com.queue.Serial")
        serialQueue.async {
            if(GlobelData.sharedInstance.setting.adminMode){
                
                
                if GlobelData.sharedInstance.persons.count != 0{
                    
                    for person in self.persons{
                        for parcel in person.parcels{
                            if parcel.state != 3{
                                parcel.refreshData()
                            }
                        }
                    }
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "saveData"), object: nil)
                    self.persons = GlobelData.sharedInstance.persons
                    self.playSound()
                }else{
                    self.persons.removeAll()
                    
                }

                
            }else{
                if GlobelData.sharedInstance.persons.count != 0{
                    
                    for person in self.persons{
                        for parcel in person.parcels{
                            if parcel.state != 3{
                                parcel.refreshData()
                            }
                        }
                    }
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "saveData"), object: nil)
                    self.persons = GlobelData.sharedInstance.persons
                    self.playSound()
                }else{
                    self.persons.removeAll()
                    
                }

            }
            
                      self.tableView.reloadData()
            self.tableView.setNeedsDisplay()
            
            self.refreshControl!.endRefreshing()
        }
        
        
        
    }
    
    func getNamesFromDataBase()->[String]{
        var names = [String]()
        let url = Foundation.URL(string:"http://hh-ss.se/webshop/service.php")
        do{
        let data = try Data(contentsOf: url!)
        
        let dataString = String(data: data, encoding: String.Encoding.utf8) as String!

            var commaSeparatedArray =  dataString!.components(separatedBy: ";")
            
            commaSeparatedArray.removeLast()
            
            for parcel in commaSeparatedArray{
                

                var stringArray = parcel.components(separatedBy: ", ")
                let name = stringArray[1].components(separatedBy: ": ")[1]
                names.append(name)
                print(name)
                
            }
            
            
        }catch{
            
        }
        
        
        return Array(Set(names))
    }
    
    func getParcelFromDataBase()->[String]{
        var parcels = [String]()
        let url = Foundation.URL(string:"http://hh-ss.se/webshop/service.php")
        do{
            let data = try Data(contentsOf: url!)
            
            let dataString = String(data: data, encoding: String.Encoding.utf8) as String!
            
            var commaSeparatedArray =  dataString!.components(separatedBy: ";")
            
            commaSeparatedArray.removeLast()
            
            for parcel in commaSeparatedArray{
                
                
                var stringArray = parcel.components(separatedBy: ", ")
                let parcel = stringArray[1].components(separatedBy: ": ")[0]
                parcels.append(parcel)
                print(parcel)
                
            }
            
            
        }catch{
            
        }
        return parcels
        
    }
    


    /*
    
    func getNamesFromDataBase()->[String]{
        var names = [String]()
        typealias JSONDictionary = [String: AnyObject]
        
        typealias JSONArray = Array<AnyObject>
        
        let url = Foundation.URL(string: "https://spreadsheets.google.com/feeds/list/1V3Pap91laxnT3FvxvTMNMVsy0M0mq014EyDQf6hqAyI/1/public/basic?alt=json")
        do {
            let data = try Data(contentsOf: url!)
            
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! JSONDictionary
            
            if let feed = json["feed"] as? JSONDictionary,let entries = feed["entry"] as? JSONArray {
                
                for (_, entry) in entries.enumerated() {
                    
                    if let name = entry["content"] as? JSONDictionary{
                        
                        if let tracing =  name["$t"] as? String{
                            var commaSeparatedArray = tracing.components(separatedBy: ", ")
                            
                            
                            let subcommaSeparatedArray2 = commaSeparatedArray[1].components(separatedBy: ": ")
                            let name2 = subcommaSeparatedArray2[1]
                            names.append(name2)
                            
                        }
                    }
                }
            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        return  Array(Set(names))
    }
 */
    
    func NameIsExsistInPerson(nameCheck:String) -> Bool{
        
        for person in persons{
            if(person.personName==nameCheck){
                return true
            }
        }
        
        
        return false
    }
    
    func NameIsExsist(nameCheck:String) -> Bool{
        
        var isExsist = false
        
        let url = Foundation.URL(string:"http://hh-ss.se/webshop/service.php")
        do{
            let data = try Data(contentsOf: url!)
            
            let dataString = String(data: data, encoding: String.Encoding.utf8) as String!
            
            var commaSeparatedArray =  dataString!.components(separatedBy: ";")
            
            commaSeparatedArray.removeLast()
            
            for parcel in commaSeparatedArray{
                
                
                var stringArray = parcel.components(separatedBy: ", ")
                let name = stringArray[1].components(separatedBy: ": ")[1]
                if(name == nameCheck){
                    isExsist = true
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
                
                for (_, entry) in entries.enumerated() {
                    
                    if let name = entry["content"] as? JSONDictionary{
                        
                        if let tracing =  name["$t"] as? String{
                            var commaSeparatedArray = tracing.components(separatedBy: ", ")
                            let subcommaSeparatedArray2 = commaSeparatedArray[1].components(separatedBy: ": ")
                            let name = subcommaSeparatedArray2[1]
                            if(name == nameCheck){
                                isExsist = true
                            }
                        }
                    }
                }
            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
 
         */
        
        return isExsist
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return persons.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons[section].parcels.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if GlobelData.sharedInstance.setting.enableDelivered{
            return persons[section].personName
        }else{
            var name = false
            for parcel in persons[section].parcels {
                if parcel.state != 3{
                    name = true
                }
            }
            
            if name{
                
                return persons[section].personName
            }
            else{
                
                return ""
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if GlobelData.sharedInstance.setting.enableDelivered{
            return 25
        }else{
            var name = false
            for parcel in persons[section].parcels {
                if parcel.state != 3{
                    name = true
                }
            }
            
            if name{
                
                return 25
            }
            else{
                
                return 0
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight:CGFloat = 0.0
        
        if GlobelData.sharedInstance.setting.enableDelivered{
            rowHeight = 99.0
        }else{
            if persons[indexPath.section].parcels[indexPath.row].state==3{
                rowHeight = 0
            }else{
                rowHeight = 99.0
            }
        }
        
        
        return rowHeight
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
        
        let cellIdentifier = "ParcelTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ParcelTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        let parcel = persons[indexPath.section].parcels[indexPath.row]
        
        cell.Name.text = parcel.name
        
        if(parcel.state==3){
            cell.icon.image = UIImage(named: "delivered")
            
        }else{
            cell.icon.image = UIImage(named: "ontheway")
        }
        
        cell.number.text = parcel.number
        if(parcel.TrackingInfos.count != 0){
            cell.recentTime.text = parcel.lastTracingTimeInfo()
            cell.recentLocation.text = parcel.lastTracingInfo()
        }else{
            cell.recentTime.text = ""
            cell.recentLocation.text = "暂无信息，打开瑞典区域试试？"
        }
        
        
        return cell
    }
    
    
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "showDetail":
            guard let parcelDetailViewController = segue.destination as? ParcelViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedParcelCell = sender as? ParcelTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedParcelCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedParcel = persons[indexPath.section].parcels[indexPath.row]
            print(selectedParcel.number)
            parcelDetailViewController.parcel = selectedParcel
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
        
    }
    
    
}
