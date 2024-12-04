//
//  SettingsViewController.swift
//  EcoClean
//
//  Created by Karen Khachatryan on 04.12.24.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setNaviagtionBackButton()
        setNavigationTitle(title: "Settings")
    }
    
    @IBAction func clickedContactUs(_ sender: UIButton) {
    }
    @IBAction func clickedPrivacyPolicy(_ sender: UIButton) {
    }
    @IBAction func clickedRateUs(_ sender: UIButton) {
    }
}
