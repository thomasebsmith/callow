//
//  EditItemVC.swift
//  Callow
//
//  Created by Thomas Smith on 1/14/19.
//  Copyright © 2019 Thomas Smith. All rights reserved.
//

import CoreGraphics
import UIKit

class EditItemVC: UIViewController {
    // MARK: - Class Properties
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var dateEntry: UIDatePicker!
    @IBOutlet weak var descriptionView: UITextView!
    
    private let incompleteBorderColor: UIColor = .red
    private let incompleteBorderWidth: CGFloat = 1.0
    private let incompleteCornerRadius: CGFloat = 5.0
    private var isTitleFieldIncomplete = false
    private var item: Item? = nil
    
    // MARK: - Private functions
    private func updateItemFields() {
        if let newItem = item {
            titleField.text = newItem.title
            if let date = newItem.date {
                dateEntry.date = date
            }
            descriptionView.text = newItem.desc
            titleFieldEditingChanged(titleField)
        }
    }

    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        updateItemFields()
    }
    
    // MARK: - Public methods
    func setItem(_ newItem: Item) {
        item = newItem
        if isViewLoaded {
            updateItemFields()
        }
    }

    // MARK: - IBActions
    @IBAction func cancelEdit(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    @IBAction func titleFieldEditingChanged(_ sender: UITextField) {
        // Remove the incomplete border around the text field if the user has now entered text
        if isTitleFieldIncomplete && titleField.text != nil && titleField.text != "" {
            isTitleFieldIncomplete = false
            titleField.layer.borderWidth = 0.0
        }
    }

    @IBAction func finishEdit(_ sender: UIBarButtonItem) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            let title = titleField.text ?? ""
            let date = dateEntry.date
            let desc = descriptionView.text ?? ""
            
            if title == "" {
                titleField.layer.borderColor = incompleteBorderColor.cgColor
                titleField.layer.borderWidth = incompleteBorderWidth
                titleField.layer.cornerRadius = incompleteCornerRadius
                isTitleFieldIncomplete = true
                return // Return prematurely so that the EditItemVC is not dismissed
            }
            guard let item = item else {
                print("No item to edit. Dismissing")
                dismiss(animated: true)
                return
            }
            item.title = title
            item.date = date
            item.desc = desc
            if !delegate.dataManager.save(item) {
                print("Unable to save new item\n")
            }
        }
        else {
            print("Unable to edit item: could not find shared app delegate\n")
        }
        dismiss(animated: true)
    }

}
