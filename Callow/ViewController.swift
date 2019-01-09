//
//  ViewController.swift
//  Callow
//
//  Created by Thomas Smith on 1/1/19.
//  Copyright © 2019 Thomas Smith. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var containerView: UIView!
    var upcomingActive = true
    var upcomingVC: UIViewController!
    var singleDayVC: UIViewController!
    
    let upcomingID = "upcomingVC"
    let singleDayID = "singleDayVC"
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        let theStoryboard = storyboard ?? UIStoryboard(name: "Main", bundle: nil)
        
        upcomingVC = theStoryboard.instantiateViewController(withIdentifier: upcomingID)
        singleDayVC = theStoryboard.instantiateViewController(withIdentifier: singleDayID)
        
        addChild(upcomingVC)
        addChild(singleDayVC)
        
        upcomingVC.view.frame = containerView.bounds
        containerView.addSubview(upcomingVC.view)
        upcomingActive = true
    }
    
    // MARK: - Navigation
    @IBAction func switchViews(_ sender: UIBarButtonItem) {
        for aView in containerView.subviews {
            aView.removeFromSuperview()
        }
        
        let newView: UIView = upcomingActive ? singleDayVC.view : upcomingVC.view
        newView.frame = containerView.bounds
        containerView.addSubview(newView)
        upcomingActive = !upcomingActive
    }

}
