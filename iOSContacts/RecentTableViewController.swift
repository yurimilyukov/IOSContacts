//
//  RecentTableViewController.swift
//  iOSContacts
//
//  Created by Milyukov Yuri on 18.03.2021.
//

import UIKit

class RecentTableViewController: UITableViewController {
    var recent:[Contact] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didGetCallNotification(_:)), name: Notification.Name("call"), object: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        recent.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentCell", for: indexPath)

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let name = recent[indexPath.section].firstName
        let time = getDate()
        cell.textLabel?.text = "\(name) at \(time)"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let phoneNumber = recent[indexPath.row].phone
        guard let number = URL(string: "tel://" + phoneNumber) else {
            return
        }
        recent.insert(recent[indexPath.row], at: 0)
        tableView.reloadData()
        UIApplication.shared.open(number)
    }

    @objc private func didGetCallNotification(_ notification : Notification){
        let contact = notification.object as! Contact
        recent.insert(contact, at: 0)
        tableView.reloadData()
    }
    private func getDate()->String{
        let time = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:ss"
        let stringDate = timeFormatter.string(from: time)
        return stringDate
       }
}
