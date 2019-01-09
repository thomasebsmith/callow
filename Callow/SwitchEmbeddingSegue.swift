//
//  SwitchEmbeddingSegue.swift
//  Callow
//
//  Created by Thomas Smith on 1/8/19.
//  Copyright © 2019 Thomas Smith. All rights reserved.
//

import UIKit

class SwitchEmbeddingSegue: UIStoryboardSegue {
    override func perform() {
        let src = source as? ViewController
        src?.switchEmbedding(destination)
    }
}
