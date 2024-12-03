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
    @IBOutlet weak var completedTasksLabel: UILabel!
    private let viewModel = MenuViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setNaviagtionRightButton()
        titleLabels.forEach({ $0.font = .medium(size: 16) })
        completedTasksLabel.font = .medium(size: 10)
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
                if tasks.isEmpty {
                    self.chartView.models = [PieSliceModel(value: 1.0, color: .baseGreen)]
                } else {
                    self.chartView.models = [PieSliceModel(value: Double(tasks.count - completedTasks.count), color: .baseOrange), PieSliceModel(value: Double(completedTasks.count), color: .baseGreen)]
                }
                let tasksCount = "\(completedTasks.count)"
                let tasksCompleted = "\ntasks completed"

                let tasksCountAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.medium(size: 38) ?? .systemFont(ofSize: 20)]
                let taksCompletedAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.regular(size: 10) ?? .systemFont(ofSize: 16)]
                let attributedTasksCount = NSAttributedString(string: tasksCount, attributes: tasksCountAttributes)
                let attributedTasksCompleted = NSAttributedString(string: tasksCompleted, attributes: taksCompletedAttributes)
                let combinedAttributedString = NSMutableAttributedString()
                combinedAttributedString.append(attributedTasksCount)
                combinedAttributedString.append(attributedTasksCompleted)
                self.completedTasksLabel.attributedText = combinedAttributedString
            }
            .store(in: &cancellables)
    }
    
    @IBAction func clickedCreateTask(_ sender: UIButton) {
        self.pushViewController(TaskFormViewController.self)
    }
    
    @IBAction func clickedTips(_ sender: UIButton) {
        self.pushViewController(TipsViewController.self)
    }
    
    @IBAction func clickedTasks(_ sender: UIButton) {
        self.pushViewController(TasksViewController.self)
    }
}
