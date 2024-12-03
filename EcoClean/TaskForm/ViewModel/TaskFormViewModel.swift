//
//  TaskFormViewModel.swift
//  EcoClean
//
//  Created by Karen Khachatryan on 03.12.24.
//

import Foundation

class TaskFormViewModel {
    static let shared = TaskFormViewModel()
    @Published var task = TaskModel(id: UUID())
    private init() {}
    
    func create(completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.saveTask(taskModel: task, completion: completion)
    }
    
    func clear() {
        task = TaskModel(id: UUID())
    }
}
