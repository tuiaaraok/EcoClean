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
    
//    func savePortfolio(portfolioModel: PortfolioModel, completion: @escaping (Error?) -> Void) {
//        let id = portfolioModel.id
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let fetchRequest: NSFetchRequest<Portfolio> = Portfolio.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
//            
//            do {
//                let results = try backgroundContext.fetch(fetchRequest)
//                let portfolio: Portfolio
//                
//                if let existingPortfolio = results.first {
//                    portfolio = existingPortfolio
//                } else {
//                    portfolio = Portfolio(context: backgroundContext)
//                    portfolio.id = id
//                }
//                
//                portfolio.fur = portfolioModel.fur
//                portfolio.info = portfolioModel.info
//                portfolio.photos = portfolioModel.photos
//                
//                try backgroundContext.save()
//                DispatchQueue.main.async {
//                    completion(nil)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(error)
//                }
//            }
//        }
//    }
//    
//    func confirmOrder(id: UUID, completion: @escaping (Error?) -> Void) {
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
//            
//            do {
//                let results = try backgroundContext.fetch(fetchRequest)
//                if let order = results.first {
//                    order.isCompleted = true
//                    order.completionDate = Date().stripTime()
//                } else {
//                    completion(NSError(domain: "CoreDataManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Order not found"]))
//                }
//                try backgroundContext.save()
//                DispatchQueue.main.async {
//                    completion(nil)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(error)
//                }
//            }
//        }
//    }
//    
//    func fetchPortfolio(completion: @escaping ([PortfolioModel], Error?) -> Void) {
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let fetchRequest: NSFetchRequest<Portfolio> = Portfolio.fetchRequest()
//            do {
//                let results = try backgroundContext.fetch(fetchRequest)
//                var portfolioModels: [PortfolioModel] = []
//                for result in results {
//                    let portfolioModel = PortfolioModel(id: result.id ?? UUID(), fur: result.fur, info: result.info, photos: result.photos ?? [])
//                    portfolioModels.append(portfolioModel)
//                }
//                DispatchQueue.main.async {
//                    completion(portfolioModels, nil)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion([], error)
//                }
//            }
//        }
//    }
//    
//    func fetchCompletedOrders(completion: @escaping ([OrderModel], Error?) -> Void) {
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "isCompleted == true")
//            
//            do {
//                let results = try backgroundContext.fetch(fetchRequest)
//                var ordersModel: [OrderModel] = []
//                for result in results {
//                    let orderModel = OrderModel(
//                        id: result.id ?? UUID(),
//                        date: result.date ?? Date().stripTime(),
//                        client: result.client,
//                        phoneNumber: result.phoneNumber,
//                        costOfMaterials: result.costOfMaterials,
//                        productCost: result.productCost,
//                        priority: Int(result.priority),
//                        info: result.info,
//                        completionDate: result.completionDate,
//                        isCompleted: result.isCompleted
//                    )
//                    ordersModel.append(orderModel)
//                }
//                DispatchQueue.main.async {
//                    completion(ordersModel, nil)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion([], error)
//                }
//            }
//        }
//    }
}

