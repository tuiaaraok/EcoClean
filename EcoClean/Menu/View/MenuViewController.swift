//
//  MenuViewController.swift
//  EcoClean
//
//  Created by Karen Khachatryan on 03.12.24.
//

import UIKit
import PieCharts

class MenuViewController: UIViewController {

    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var chartView: PieChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNaviagtionRightButton()
        titleLabels.forEach({ $0.font = .medium(size: 16) })
        chartView.models = [
            PieSliceModel(value: 2.1, color: UIColor.yellow),
            PieSliceModel(value: 3, color: UIColor.blue),
        ]
    }
}
