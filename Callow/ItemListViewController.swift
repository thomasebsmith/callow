//
//  ItemListViewController.swift
//  Callow
//
//  Created by Thomas Smith on 1/6/19.
//  Copyright © 2019 Thomas Smith. All rights reserved.
//

import UIKit

class ItemListViewController: UITableViewController {
    // MARK: - Class Properties
    private let reuseIdentifier = "itemCell"
    private let cellTag = 1
    private let itemDetailsSegueIdentifier = "itemDetailsSegue"
    private var selectedItem: Item? = nil
    private var items: [Item] = []
    private var dataManager : DataManager? = nil
    
    // MARK: - Custom methods
    func setItems(_ newItems: [Item]) {
        items = newItems
        tableView.reloadData()
    }
    
    func formatText(_ item: Item) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        var time = ""
        if let date = item.date {
            time = dateFormatter.string(from: date) + " — "
        }
        let title = item.title ?? ""
        // Descriptions are not shown in the table view
        
        return time + title
    }
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            dataManager = delegate.dataManager
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        if cell.tag != cellTag {
            let item = items[indexPath.row]
            let text = formatText(item)
            if let label = cell.textLabel {
                label.text = text
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = items.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            if !(dataManager?.deleteItem(item) ?? false) {
                print("Unable to delete item\n")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = items[indexPath.row]
        self.performSegue(withIdentifier: itemDetailsSegueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == itemDetailsSegueIdentifier {
            if let itemDetailsVC = segue.destination as? ItemDetailsVC {
                itemDetailsVC.setItem(selectedItem)
            }
        }
    }

}
