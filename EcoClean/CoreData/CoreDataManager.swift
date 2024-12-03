//
//  CoreDataManager.swift
//  EcoClean
//
//  Created by Karen Khachatryan on 03.12.24.
//


import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EcoClean")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveTask(taskModel: TaskModel, completion: @escaping (Error?) -> Void) {
        let id = taskModel.id
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let task: Task
                
                if let existingTask = results.first {
                    task = existingTask
                } else {
                    task = Task(context: backgroundContext)
                    task.id = id
                }
                
                task.name = taskModel.name
                task.location = taskModel.location
                task.executor = taskModel.executor
                task.status = Int32(taskModel.status)
                task.deadline = taskModel.deadline
                
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func fetchTasks(completion: @escaping ([TaskModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var tasksModel: [TaskModel] = []
                for result in results {
                    let taskModel = TaskModel(id: result.id ?? UUID(), name: result.name, location: result.location, executor: result.executor, status: Int(result.status), deadline: result.deadline)
                    tasksModel.append(taskModel)
                }
                DispatchQueue.main.async {
                    completion(tasksModel, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
    
    func changeTaskStatus(id: UUID, status: Int, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if let order = results.first {
                    order.status = Int32(status)
                } else {
                    completion(NSError(domain: "CoreDataManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Task not found"]))
                }
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func removeTask(by id: UUID, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if let taskToRemove = results.first {
                    backgroundContext.delete(taskToRemove)
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Task not found"]))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func saveTip(tipModel: TipModel, completion: @escaping (Error?) -> Void) {
        let id = tipModel.id
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Tip> = Tip.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let tip: Tip
                
                if let existingTip = results.first {
                    tip = existingTip
                } else {
                    tip = Tip(context: backgroundContext)
                    tip.id = id
                }
                
                tip.info = tipModel.info
                tip.header = tipModel.header
                
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func fetchTips(completion: @escaping ([TipModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Tip> = Tip.fetchRequest()
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var tipsModel: [TipModel] = []
                for result in results {
                    let tipModel = TipModel(id: result.id ?? UUID(), header: result.header, info: result.info)
                    tipsModel.append(tipModel)
                }
                DispatchQueue.main.async {
                    completion(tipsModel, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
}

