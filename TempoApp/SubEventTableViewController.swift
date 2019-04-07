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

class SubEventTableViewController: UITableViewController {

    var tdata:[Event] = []

    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        let id = defaults.integer(forKey: defaultsKeys.keyTwo)
        print("ID IS: \(id)")
        let authkey = defaults.string(forKey: defaultsKeys.keyOne)

        let headers: HTTPHeaders = [
            "Authorization": authkey!
        ]
        AF.request("https://api.tempoapp.pro/v1/event/\(id)/children", method: .get, headers: headers).responseJSON { response in
            print(response)
            if response.response?.statusCode == 429 {
                self.viewDidLoad()
            }
            if response.response?.statusCode == 400 {
                
            } else {
                let json = JSON(response.data as Any)
                for (_, subJson) in json {
                    if subJson["name"].string != nil {
                        let ev = Event(name: subJson["name"].string!, description: subJson["description"].string!, rating: subJson["difficulty"].double ?? 0.0, id: subJson["id"].int ?? 0)
                        self.tdata.append(ev)
                    }
                    print("Length: \(self.tdata.count)")
                }
                self.tableView.reloadData()
            }
            
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tdata.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell

        print(indexPath.row)
        print("Le data: \(tdata[indexPath.row])")
        print("Le name: \(tdata[indexPath.row].name)")
        print("Length of array: \(tdata.count)")
        
        let bob = "\(tdata[indexPath.row].name)"

        cell.titleLabel.text = bob ?? "Nope"
        cell.descriptionLabel.text = tdata[indexPath.row].description ?? "Nope"
        cell.cosmos.rating = tdata[indexPath.row].rating ?? 0.0

        return cell
    }

    /*override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row selected: \(indexPath.row)")
        let cell = tableView.cellForRow(at: indexPath as IndexPath)

        var id = tids[indexPath.row]

        defaults.set(id, forKey: defaultsKeys.keyTwo)

        self.performSegue(withIdentifier: "ToEventDetailSegue", sender: self)
    } */

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}
