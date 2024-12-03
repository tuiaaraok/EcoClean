//
//  TaskFormViewController.swift
//  EcoClean
//
//  Created by Karen Khachatryan on 03.12.24.
//

import UIKit
import Combine

class TaskFormViewController: UIViewController {

    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var createButton: BaseButton!
    @IBOutlet weak var nameTextField: BaseTextField!
    @IBOutlet weak var locationTextField: BaseTextField!
    @IBOutlet weak var executorTextField: BaseTextField!
    @IBOutlet weak var deadlineTextField: BaseTextField!
    private let viewModel = TaskFormViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    private let datePicker = UIDatePicker()
    var completion: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
    }
    
    func setupUI() {
        setNaviagtionBackButton()
        setNavigationTitle(title: "Add task")
        titleLabels.forEach({ $0.font = .regular(size: 22) })
        nameTextField.delegate = self
        locationTextField.delegate = self
        executorTextField.delegate = self
        datePicker.locale = NSLocale.current
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        deadlineTextField.inputView = datePicker
    }
    
    func subscribe() {
        viewModel.$task
            .receive(on: DispatchQueue.main)
            .sink { [weak self] task in
                guard let self = self else { return }
                nameTextField.text = task.name
                locationTextField.text = task.location
                executorTextField.text = task.executor
                deadlineTextField.text = task.deadline?.toString()
                self.createButton.isEnabled = (task.name.checkValidation() && task.location.checkValidation() && task.executor.checkValidation() && task.deadline != nil)
            }
            .store(in: &cancellables)
    }
    
    @objc func datePickerValueChanged() {
        viewModel.task.deadline = datePicker.date
    }
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func clickedCreate(_ sender: BaseButton) {
        viewModel.create { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                self.completion?()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    deinit {
        viewModel.clear()
    }
}

extension TaskFormViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case nameTextField:
            viewModel.task.name = textField.text
        case locationTextField:
            viewModel.task.location = textField.text
        case executorTextField:
            viewModel.task.executor = textField.text
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
