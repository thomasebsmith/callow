//
//  DailyViewVC.swift
//  Callow
//
//  Created by Thomas Smith on 9/11/18.
//  Copyright © 2018 Thomas Smith. All rights reserved.
//

import UIKit

class DailyViewVC: UITableViewController {
    
    // MARK: - Class Properties
    // Day defaults to current date (today) if not specified
    private var day = Date(timeIntervalSinceNow: 0)
    private var dataManager : DataManager? = nil
    private var items : [Item] = []
    private let reuseIdentifier = "dailyViewCell"
    private let cellTag = 1
    
    // MARK: - Custom Methods
    func loadItems() {
        if let manager = dataManager {
            items = manager.getItemsForDay(day: day)
        }
        else {
            print("No data manager. Using empty items array\n")
            items = []
        }
        self.tableView.reloadData()
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
    
    func setDay(_ newDay: Date) {
        // Reload the items in the table if a new day is specified
        if !Calendar.current.isDate(newDay, inSameDayAs: day) {
            day = newDay
            loadItems()
        }
    }
    
    func getDay() -> Date {
        return day
    }
    
    func goBackOneDay() {
        if let newDay = Calendar.current.date(byAdding: .day, value: -1, to: day) {
            setDay(newDay)
        }
    }
    
    func goForwardOneDay() {
        if let newDay = Calendar.current.date(byAdding: .day, value: 1, to: day) {
            setDay(newDay)
        }
    }
    
    // MARK: - Overrides
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = items.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            if !(dataManager?.deleteItem(item) ?? false) {
                print("Unable to delete item\n")
            }
        }
    }
    
    override func viewDidLoad() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            dataManager = delegate.dataManager
        }
        loadItems()
    }
}
