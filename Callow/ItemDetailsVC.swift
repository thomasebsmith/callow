//
//  ItemDetailsVC.swift
//  Callow
//
//  Created by Thomas Smith on 9/15/18.
//  Copyright © 2018 Thomas Smith. All rights reserved.
//

import UIKit

class ItemDetailsVC: UIViewController {
    
    // MARK: - Class Properties
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var item: Item? = nil
    private let editItemSegueID = "editItemSegue"
    
    // MARK: - Private Methods
    private func getTitleText() -> String {
        return item?.title ?? "No Title"
    }
    private func getDateTimeText() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        if let date = item?.date {
            return dateFormatter.string(from: date)
        }
        return ""
    }
    private func getDescriptionText() -> String {
        return item?.desc ?? ""
    }
    
    // MARK: - Public Methods
    func loadItemContent() {
        navigationBar.topItem?.title = getTitleText()
        dateTimeLabel.text = getDateTimeText()
        descriptionLabel.text = getDescriptionText()
    }
    
    func setItem(_ newItem: Item?) {
        item = newItem
    }
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItemContent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    @IBAction func closeItemDetails(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == editItemSegueID {
            guard let controller = segue.destination as? EditItemVC else {
                print("Invalid edit item segue")
                return
            }
            guard let item = item else {
                print("No item when segueing to edit item")
                return
            }
            controller.setItem(item)
        }
    }

}
