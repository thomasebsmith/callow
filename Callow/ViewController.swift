//
//  ViewController.swift
//  Callow
//
//  Created by Thomas Smith on 1/1/19.
//  Copyright © 2019 Thomas Smith. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var embeddedVC: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        embeddedVC = segue.destination
    }

}
