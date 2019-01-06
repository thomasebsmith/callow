//
//  UpcomingViewController.swift
//  Callow
//
//  Created by Thomas Smith on 1/5/19.
//  Copyright © 2019 Thomas Smith. All rights reserved.
//

import UIKit

class UpcomingViewController: UITableViewController {
    // MARK: - Class properties
    private var today = Date(timeIntervalSinceNow: 0)
    private var dataManager : DataManager? = nil
    private var items : [Item] = []
    private let maxItems = 20
    
    private let reuseIdentifier = "upcomingViewCell"
    private let cellTag = 1
    private let itemDetailsSegueIdentifier = "itemDetailsSegue"
    private var selectedItem: Item? = nil
    
    // MARK: - Custom methods
    func loadUpcomingItems() {
        var dayToLoad = today
        guard let manager = dataManager else {
            print("Invalid data manager")
            return
        }
        while items.count < maxItems && manager.hasEventsAfter(day: dayToLoad) {
            items += manager.getItemsForDay(day: dayToLoad)
            if let newDay = Calendar.current.date(byAdding: .day, value: 1, to: dayToLoad) {
                dayToLoad = newDay
            }
            else {
                break
            }
        }
        items = Array(items.prefix(maxItems))
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
        loadUpcomingItems()
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

}
