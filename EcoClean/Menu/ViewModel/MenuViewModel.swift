//
//  MenuViewModel.swift
//  EcoClean
//
//  Created by Karen Khachatryan on 03.12.24.
//

import Foundation

class MenuViewModel {
    static let shared = MenuViewModel()
    @Published var tasks: [TaskModel] = []
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchTasks { [weak self] tasks, _ in
            guard let self = self else { return }
            self.tasks = tasks
        }
    }
}
