//
//  MenuViewController.swift
//  EcoClean
//
//  Created by Karen Khachatryan on 03.12.24.
//

import UIKit
import PieCharts
import Combine

class MenuViewController: UIViewController {

    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var chartView: PieChart!
    private let viewModel = MenuViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setNaviagtionRightButton()
        titleLabels.forEach({ $0.font = .medium(size: 16) })
        subscribe()
        viewModel.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchData()
    }
    
    func subscribe() {
        viewModel.$tasks
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tasks in
                guard let self = self else { return }
                let completedTasks = tasks.filter({ $0.status == 1 })
                self.chartView.clear()
                self.chartView.models = [
                    PieSliceModel(value: Double(completedTasks.count), color: .baseGreen),
                    PieSliceModel(value: Double(tasks.count - completedTasks.count), color: .baseOrange),
                ]
            }
            .store(in: &cancellables)
    }
    
    @IBAction func clickedCreateTask(_ sender: UIButton) {
        self.pushViewController(TaskFormViewController.self)
    }
    
    @IBAction func clickedTips(_ sender: UIButton) {
    }
    
    @IBAction func clickedTasks(_ sender: UIButton) {
        self.pushViewController(TasksViewController.self)
    }
}
