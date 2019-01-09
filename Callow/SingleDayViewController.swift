//
//  SingleDayViewController.swift
//  Callow
//
//  Created by Thomas Smith on 9/11/18.
//  Copyright © 2018 Thomas Smith. All rights reserved.
//

import UIKit

class SingleDayViewController: UIViewController {
    
    // MARK: - Class Properties
    @IBOutlet weak var dayNavigationBar: UINavigationBar!
    
    // Day defaults to current date (today) if not specified
    private var day = Date(timeIntervalSinceNow: 0)
    private var dataManager : DataManager? = nil
    private var itemListVC: ItemListViewController? = nil
    private let itemListSegueIdentifier = "singleDayItemListEmbed"
    
    // MARK: - Custom Methods
    func loadItems() {
        guard let itemListVC = itemListVC else {
            print("No ItemListViewController found when loading items.")
            return
        }
        guard let manager = dataManager else {
            print("Invalid data manager")
            return
        }
        itemListVC.setItems(manager.getItemsForDay(day: day))
    }
    
    func updateDisplayedDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.doesRelativeDateFormatting = true
        let dayDisplayText = dateFormatter.string(from: day)
        dayNavigationBar.topItem?.title = dayDisplayText
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
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDisplayedDate()
        dataManager?.onUpdate({ (day) in
            if Calendar.current.isDate(day, inSameDayAs: day) {
                self.loadItems()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == itemListSegueIdentifier {
            if let theItemListVC = segue.destination as? ItemListViewController {
                if let delegate = UIApplication.shared.delegate as? AppDelegate {
                    dataManager = delegate.dataManager
                }
                itemListVC = theItemListVC
                loadItems()
            }
        }
    }
    
    // MARK: - Navigation
    @IBAction func goBackOneDay(_ sender: UIBarButtonItem) {
        goBackOneDay()
        updateDisplayedDate()
    }
    
    @IBAction func goForwardOneDay(_ sender: UIBarButtonItem) {
        goForwardOneDay()
        updateDisplayedDate()
    }
    
    
}

