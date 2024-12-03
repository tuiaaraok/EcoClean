//
//  TipFormViewModel.swift
//  EcoClean
//
//  Created by Karen Khachatryan on 04.12.24.
//

import Foundation

class TipFormViewModel {
    static let shared = TipFormViewModel()
    @Published var tip = TipModel(id: UUID())
    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.saveTip(tipModel: tip, completion: completion)
    }
    
    func clear() {
        tip = TipModel(id: UUID())
    }
}
