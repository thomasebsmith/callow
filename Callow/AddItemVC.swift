//
//  AddItemVC.swift
//  Callow
//
//  Created by Thomas Smith on 9/11/18.
//  Copyright © 2018 Thomas Smith. All rights reserved.
//

import UIKit

class AddItemVC: UIViewController {

    // MARK: - Class Properties
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var dateEntry: UIDatePicker!
    @IBOutlet weak var descriptionView: UITextView!
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Navigation
    @IBAction func cancelNewItem(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            let title = titleField.text ?? ""
            let date = dateEntry.date
            let desc = descriptionView.text ?? ""
            
            if title == "" {
                titleField.tintColor = UIColor.red
                return // Return prematurely so that the AddItemVC is not dismissed
            }
            else if !delegate.dataManager.addItem(title: title, date: date, desc: desc) {
                print("Unable to save new item\n")
            }
        }
        else {
            print("Unable to add new item: could not find shared app delegate\n")
        }
        self.dismiss(animated: true)
    }
}
