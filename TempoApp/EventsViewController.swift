//
//  EventsViewController.swift
//  TempoApp
//
//  Created by Chew on 4/7/19.
//  Copyright © 2019 TempoApp Development. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Event {
    var name:String
    var description:String
    var rating:Double
    var id:Int
}

class EventsViewController: UITableViewController {
    
    var tdata:[Event] = []
    
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let authkey = defaults.string(forKey: defaultsKeys.keyOne)
        
        let headers: HTTPHeaders = [
            "Authorization": authkey!
        ]
        
        AF.request("https://api.tempoapp.pro/v1/event/all", method: .get, headers: headers).responseJSON { response in
            print(response)
            if response.response?.statusCode == 429 {
                return
            }
            let json = JSON(response.data as Any)
            for (_, subJson) in json {
                if subJson["parent"].int == 0 {
                    let ev = Event(name: subJson["name"].string!, description: subJson["description"].string!, rating: subJson["difficulty"].double!, id: subJson["id"].int!)
                    self.tdata.append(ev)
                    print(self.tdata)
                }
                
            }
            self.tableView.reloadData()
        }
    }
    
    @IBAction func goToCreate(_ sender: Any) {
        self.performSegue(withIdentifier: "ToCreateEventSegue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tdata.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        
        print(indexPath.row)
        print(tdata)
        
        cell.titleLabel.text = tdata[indexPath.row].name
        cell.descriptionLabel.text = tdata[indexPath.row].description
        cell.cosmos.rating = tdata[indexPath.row].rating
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row selected: \(indexPath.row)")
        let cell = tableView.cellForRow(at: indexPath as IndexPath)
        
        var id = tdata[indexPath.row].id
        
        defaults.set(id, forKey: defaultsKeys.keyTwo)
        
        self.performSegue(withIdentifier: "ToEventDetailSegue", sender: self)
    }
}
