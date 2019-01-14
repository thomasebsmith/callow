//
//  UpcomingVC
//  Callow
//
//  Created by Thomas Smith on 1/5/19.
//  Copyright © 2019 Thomas Smith. All rights reserved.
//

import UIKit

class UpcomingVC: UIViewController {
    // MARK: - Class properties
    private var today = Date(timeIntervalSinceNow: 0)
    private var dataManager : DataManager? = nil
    private let maxItems = 20
    private let itemListSegueIdentifier = "upcomingItemListEmbed"
    private var itemListVC: ItemListVC? = nil
    
    // MARK: - Custom methods
    func loadItems() {
        guard let itemListVC = itemListVC else {
            print("No ItemListViewController found when loading items.")
            return
        }
        itemListVC.setItems(getUpcomingItems())
    }
    
    func getUpcomingItems() -> [Item] {
        var dayToLoad = today
        var items: [Item] = []
        guard let manager = dataManager else {
            print("Invalid data manager")
            return items
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
        return Array(items.prefix(maxItems))
    }
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager?.onUpdate({ (day) in
            if Calendar.current.isDate(day, inSameDayAs: self.today) || day > self.today {
                self.loadItems()
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == itemListSegueIdentifier {
            if let theItemListVC = segue.destination as? ItemListVC {
                if let delegate = UIApplication.shared.delegate as? AppDelegate {
                    dataManager = delegate.dataManager
                }
                itemListVC = theItemListVC
                loadItems()
            }
        }
    }

}
