//
//  ViewController.swift
//  Callow
//
//  Created by Thomas Smith on 9/11/18.
//  Copyright © 2018 Thomas Smith. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Class Properties
    @IBOutlet weak var dayNavigationBar: UINavigationBar!
    
    var dailyViewVC: DailyViewVC?
    
    lazy var dataManager: DataManager? = {
        return (UIApplication.shared.delegate as? AppDelegate)?.dataManager
    }()
    
    // MARK: - Custom Methods
    func updateDisplayedDate() {
        if let dailyVC = dailyViewVC {
            let newDay = dailyVC.getDay()
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.doesRelativeDateFormatting = true
            let dayDisplayText = dateFormatter.string(from: newDay)
            dayNavigationBar.topItem?.title = dayDisplayText
        }
    }
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDisplayedDate()
        dataManager?.onUpdate({ (day) in
            if let dailyVC = self.dailyViewVC {
                if Calendar.current.isDate(day, inSameDayAs: dailyVC.getDay()) {
                    dailyVC.loadItems()
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        
        case let dailyViewVCFromSegue as DailyViewVC:
            dailyViewVC = dailyViewVCFromSegue

        default:
            break
        }
    }
    
    // MARK: - Navigation
    @IBAction func goBackOneDay(_ sender: UIBarButtonItem) {
        dailyViewVC?.goBackOneDay()
        updateDisplayedDate()
    }
    
    @IBAction func goForwardOneDay(_ sender: UIBarButtonItem) {
        dailyViewVC?.goForwardOneDay()
        updateDisplayedDate()
    }
    
    
}

