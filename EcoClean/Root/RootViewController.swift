//
//  ViewController.swift
//  EcoClean
//
//  Created by Karen Khachatryan on 03.12.24.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.viewControllers = [MenuViewController(nibName: "MenuViewController", bundle: nil)]
    }
}

