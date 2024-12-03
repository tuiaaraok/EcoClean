//
//  TaskTableViewCell.swift
//  EcoClean
//
//  Created by Karen Khachatryan on 03.12.24.
//

import UIKit
import DropDown

protocol TaskTableViewCellDelegate: AnyObject {
    func changeStatus(by id: UUID, status: Int)
    func editTask(by id: UUID)
    func removeTask(by id: UUID)
}

class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var executorLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var dropDownImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var statusView: UIView!
    private let dropDown = DropDown()
    private var id: UUID?
    weak var delegate: TaskTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor.black.cgColor
        nameLabel.font = .regular(size: 18)
        labels.forEach({ $0.font = .regular(size: 16) })
        
        let data: [String] = Status.allCases.map { $0.rawValue }
        dropDown.backgroundColor = .white
        dropDown.layer.cornerRadius = 16
        dropDown.dataSource = data
        dropDown.anchorView = stackView
        dropDown.direction = .bottom
        DropDown.appearance().textColor = .black
        DropDown.appearance().textFont = .regular(size: 18) ?? .boldSystemFont(ofSize: 18)
        dropDown.addShadow()
        
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.statusButton.setTitle("Status: \(Status.allCases[index].rawValue)", for: .normal)
            self.dropDownImageView.isHighlighted = false
            if let id = id {
                delegate?.changeStatus(by: id, status: index)
            }
                
        }
        
        dropDown.cancelAction = { [weak self] in
            guard let self = self else { return }
            self.dropDownImageView.isHighlighted = false
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        id = nil
    }
    
    func configure(task: TaskModel) {
        id = task.id
        nameLabel.text = task.location
        statusButton.setTitle("Status: \(Status.allCases[task.status].rawValue)", for: .normal)
        executorLabel.text = "Executor: \(task.executor ?? "")"
        deadlineLabel.text = "Deadline: \(task.deadline?.toString(format: "HH:mm, dd/MM/yy") ?? "")"
        DispatchQueue.main.async {
            self.dropDown.width = self.statusButton.bounds.width
            self.dropDown.bottomOffset = CGPoint(x: self.statusButton.frame.minX, y: self.statusButton.frame.maxY + 2)
        }
    }
    
    @IBAction func chooseStatus(_ sender: UIButton) {
        dropDown.show()
        dropDownImageView.isHighlighted = !dropDown.isHidden
    }
    
    @IBAction func clickedEdit(_ sender: UIButton) {
        if let id = id {
            delegate?.editTask(by: id)
        }
    }
    
    @IBAction func clickedRemove(_ sender: UIButton) {
        if let id = id {
            delegate?.removeTask(by: id)
        }
    }
}

enum Status: String, CaseIterable {
    case inProgress = "In progress"
    case completed = "Completed"
}
