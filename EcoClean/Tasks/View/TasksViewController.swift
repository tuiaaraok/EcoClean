//
//  TasksViewController.swift
//  EcoClean
//
//  Created by Karen Khachatryan on 03.12.24.
//

import UIKit
import Combine

class TasksViewController: UIViewController {

    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet var filtersButton: [FilterButton]!
    @IBOutlet weak var tasksTableView: UITableView!
    private let viewModel = TasksViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
        viewModel.fetchData()
    }

    func setupUI() {
        setNaviagtionBackButton()
        setNavigationTitle(title: "List tasks")
        filterLabel.font = .medium(size: 18)
        tasksTableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskTableViewCell")
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
    }
    
    func subscribe() {
        viewModel.$tasks
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tasks in
                guard let self = self else { return }
                filtersButton.forEach({ $0.isSelected = false })
                filtersButton[self.viewModel.selectedFilter].isSelected = true
                self.tasksTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    func openTaskForm() {
        let taskFormVC = TaskFormViewController(nibName: "TaskFormViewController", bundle: nil)
        taskFormVC.completion = { [weak self] in
            if let self = self {
                self.viewModel.fetchData()
            }
        }
        self.navigationController?.pushViewController(taskFormVC, animated: true)
    }
    
    @IBAction func chooseFilter(_ sender: FilterButton) {
        viewModel.filterTasks(by: sender.tag)
    }
}

extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        cell.configure(task: viewModel.tasks[indexPath.section])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        10
    }
}

extension TasksViewController: TaskTableViewCellDelegate {
    func changeStatus(by id: UUID, status: Int) {
        viewModel.changeTaskStatus(by: id, status: status) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                self.viewModel.fetchData()
            }
        }
    }
    
    func editTask(by id: UUID) {
        if let task = viewModel.tasks.first(where: { $0.id == id }) {
            TaskFormViewModel.shared.task = task
            openTaskForm()
        }
    }
    
    func removeTask(by id: UUID) {
        viewModel.removeTask(by: id) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                self.viewModel.fetchData()
            }
        }
    }
}
