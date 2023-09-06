//
//  ViewController.swift
//  social-board
//
//  Created by 이지수 on 2023/08/25.
//

import UIKit

class ViewController: UIViewController {
    convenience init(title: String, bgColor: UIColor) {
        self.init()
        self.title = title
        self.view.backgroundColor = bgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

