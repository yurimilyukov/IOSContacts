//
//  ContactsTableViewController.swift
//  iOSContacts
//
//  Created by Milyukov Yuri on 18.03.2021.
//

import UIKit
import Dispatch

class ContactsTableViewController: UITableViewController {
    private var contacts:[Contact] = [Contact(firstName: "sfsdf", lastName: "adasd", email: "adasdas", phone: "2543502298")] //:[String]?
    private let backgroundWorkQueue = DispatchQueue(label: "com.example.iOSContacts", qos: .background)
    private let contactsRepository = GistConstactsRepository(path: "https://gist.githubusercontent.com/artgoncharov/d257658423edd46a9ead5f721b837b8c/raw/c38ace33a7c871e4ad3b347fc4cd970bb45561a3/contacts_data.json")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundWorkQueue.async {
            if let result = try? self.contactsRepository.getContacts(){
                self.contacts = result
            }
        }
        backgroundWorkQueue.async {
            if(!self.contacts.isEmpty){
                self.contacts.sort{
                    $0.firstName < $1.firstName
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(sender:)))
        tableView.addGestureRecognizer(longPress)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(didGetAddContactNotification(_:)), name: Notification.Name("addContact"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didGetEditContactNotification(_:)), name: Notification.Name("editContact"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didGetDeleteContactNotification(_:)), name: Notification.Name("deleteContact"), object: nil)
    }
    
       
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        cell.textLabel?.text = "\(contacts[indexPath.row].firstName) \(contacts[indexPath.row].lastName)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NotificationCenter.default.post(name: Notification.Name("call"), object: contacts[indexPath.row])
        guard let number = URL(string: "tel://" + contacts[indexPath.row].phone) else { return }
        UIApplication.shared.open(number)
    }
    
    @objc private func longPress(sender: UILongPressGestureRecognizer){
        if sender.state == UIGestureRecognizer.State.began {
            
            let touchPoint = sender.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint){
                
                if let editView = storyboard?.instantiateViewController(identifier: "editContactViewController"){
                    editView.modalPresentationStyle = .fullScreen
                    present(editView,animated: true)
                    let sendedContact = contacts[indexPath.row]
                    
                    NotificationCenter.default.post(name: Notification.Name("contactToEdit"), object: (indexPath.row, sendedContact))
                    
                }
            }
        }
    }
    
    @objc private func didGetAddContactNotification(_ notification: Notification){
        let contact = notification.object as! (Contact)
        contacts.append(contact)
        
        backgroundWorkQueue.async {
            if(!self.contacts.isEmpty){
                self.contacts.sort{
                    $0.firstName < $1.firstName
                }
            }
        }
        backgroundWorkQueue.async {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    @objc private func didGetEditContactNotification(_ notification: Notification){
        let contact = notification.object as! (Int, Contact)
        contacts[contact.0] = contact.1
        backgroundWorkQueue.async {
            if(!self.contacts.isEmpty){
                self.contacts.sort{
                    $0.firstName < $1.firstName
                }
            }
        }
        backgroundWorkQueue.async {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    @objc private func didGetDeleteContactNotification(_ notification: Notification){
        let contactId = notification.object as! Int
        contacts.remove(at: contactId)
        backgroundWorkQueue.async {
            if(!self.contacts.isEmpty){
                self.contacts.sort{
                    $0.firstName < $1.firstName
                }
            }
        }
        backgroundWorkQueue.async {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}
extension ContactsTableViewController : UIGestureRecognizerDelegate{
    
}
