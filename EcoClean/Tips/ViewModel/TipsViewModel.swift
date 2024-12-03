//
//  TipsViewModel.swift
//  EcoClean
//
//  Created by Karen Khachatryan on 04.12.24.
//

import Foundation

class TipsViewModel {
    static let shared = TipsViewModel()
    @Published var tips: [TipModel] = []
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchTips { [weak self] tips, _ in
            guard let self = self else { return }
            self.tips = tips
        }
    }
    
    func clear() {
        tips = []
    }
}
