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
    
    // MARK: - Custom functions
    func switchEmbedding(_ vc: UIViewController) {
        addChild(vc)
        if let embeddedVC = embeddedVC {
            transition(from: embeddedVC, to: vc, duration: 0.5, options: .curveLinear, animations: nil, completion: nil)
        }
        embeddedVC = vc
    }
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        embeddedVC = segue.destination
    }

}
