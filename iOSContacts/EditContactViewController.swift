//
//  editContactViewController.swift
//  iOSContacts
//
//  Created by Milyukov Yuri on 21.03.2021.
//

import UIKit

class EditContactViewController: UIViewController {
    @IBOutlet var nameField: UITextField!
    @IBOutlet var phoneNumberField: UITextField!
    private var contactId : Int?
    private var contactToEdit : Contact?
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didGetToEditNotification(_:)), name: Notification.Name("contactToEdit"), object: nil)
    }
    
    @IBAction private func deleteContact(){
        if let id = contactId{
            NotificationCenter.default.post(name: Notification.Name("deleteContact"), object: id)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func cancelContact(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func editContact(){
        if let name = nameField.text{
            if let phoneNumber = phoneNumberField.text{
                if let id = contactId{
                    if var contact = contactToEdit{
                        contact.firstName = name
                        contact.phone = phoneNumber
                        NotificationCenter.default.post(name: Notification.Name("editContact"), object: (id, contact))
                    }
                }
            }
        }
        dismiss(animated: true, completion: nil)

    }
    
    @objc private func didGetToEditNotification(_ notification: Notification){
        let contact = notification.object as! (Int, Contact)
        contactToEdit = contact.1
        contactId = contact.0
        nameField.text = contactToEdit?.firstName
        phoneNumberField.text = contactToEdit?.phone
    }
    
    
}

