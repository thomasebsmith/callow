//
//  AddItemVC.swift
//  Callow
//
//  Created by Thomas Smith on 9/11/18.
//  Copyright © 2018 Thomas Smith. All rights reserved.
//

import CoreGraphics
import UIKit

class AddItemVC: UIViewController {

    // MARK: - Class Properties
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var dateEntry: UIDatePicker!
    @IBOutlet weak var descriptionView: UITextView!
    
    private let incompleteBorderColor: UIColor = .red
    private let incompleteBorderWidth: CGFloat = 1.0
    private let incompleteCornerRadius: CGFloat = 5.0
    private var isTitleFieldIncomplete = false
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Navigation and Other IBActions
    @IBAction func titleFieldEditingChanged(_ sender: UITextField) {
        // Remove the incomplete border around the text field if the user has now entered text
        if isTitleFieldIncomplete && titleField.text != nil && titleField.text != "" {
            isTitleFieldIncomplete = false
            titleField.layer.borderWidth = 0.0
        }
    }
    @IBAction func cancelNewItem(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            let title = titleField.text ?? ""
            let date = dateEntry.date
            let desc = descriptionView.text ?? ""
            
            if title == "" {
                titleField.layer.borderColor = incompleteBorderColor.cgColor
                titleField.layer.borderWidth = incompleteBorderWidth
                titleField.layer.cornerRadius = incompleteCornerRadius
                isTitleFieldIncomplete = true
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
