//
//  TasksViewModel.swift
//  EcoClean
//
//  Created by Karen Khachatryan on 03.12.24.
//

import Foundation

class TasksViewModel {
    static let shared = TasksViewModel()
    private var data: [TaskModel] = []
    @Published var tasks: [TaskModel] = []
    var selectedFilter: Int = 2
    
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchTasks { [weak self] tasks, _ in
            guard let self = self else { return }
            self.data = tasks
            filterTasks(by: selectedFilter)
        }
    }
    
    func changeTaskStatus(by id: UUID, status: Int, completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.changeTaskStatus(id: id, status: status, completion: completion)
    }
    
    func removeTask(by id: UUID, completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.removeTask(by: id, completion: completion)
    }
    
    func filterTasks(by index: Int) {
        selectedFilter = index
        if index == 2 {
            tasks = data
        } else {
            tasks = data.filter({ $0.status == index })
        }
    }
    
    func clear() {
        selectedFilter = 2
        data = []
        tasks = []
    }
}
