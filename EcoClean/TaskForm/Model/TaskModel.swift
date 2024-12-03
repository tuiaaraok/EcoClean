//
//  TaskModel.swift
//  EcoClean
//
//  Created by Karen Khachatryan on 03.12.24.
//

import Foundation

struct TaskModel {
    var id: UUID
    var name: String?
    var location: String?
    var executor: String?
    var status: Int = 1
    var deadline: Date?
}
