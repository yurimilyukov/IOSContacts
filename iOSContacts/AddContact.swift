//
//  AddContact.swift
//  iOSContacts
//
//  Created by Milyukov Yuri on 21.03.2021.
//

import UIKit

class AddContact: UIViewController {
    @IBOutlet var nameField: UITextField!
    @IBOutlet var phoneNumberField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func saveNewContact(){
        
        if let name = nameField.text{
            if let phoneNumber = phoneNumberField.text{
                NotificationCenter.default.post(name: Notification.Name("addContact"),object: Contact(firstName: name, lastName: name, email: "boop", phone: phoneNumber))
            }
        }
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

}
