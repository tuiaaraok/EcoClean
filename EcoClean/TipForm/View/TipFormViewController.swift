//
//  TipFormViewController.swift
//  EcoClean
//
//  Created by Karen Khachatryan on 04.12.24.
//

import UIKit
import Combine

class TipFormViewController: UIViewController {

    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var headerTextField: BaseTextField!
    @IBOutlet weak var descriptionTextField: BaseTextField!
    @IBOutlet weak var createButton: BaseButton!
    private let viewModel = TipFormViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    var completion: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
    }
    
    func setupUI() {
        setNaviagtionBackButton()
        setNavigationTitle(title: "Add a tip")
        titleLabels.forEach({ $0.font = .regular(size: 22) })
        headerTextField.delegate = self
        descriptionTextField.delegate = self
    }
    
    func subscribe() {
        viewModel.$tip
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tip in
                guard let self = self else { return }
                self.headerTextField.text = tip.header
                self.descriptionTextField.text = tip.info
                self.createButton.isEnabled = (tip.header.checkValidation() && tip.info.checkValidation())
            }
            .store(in: &cancellables)
    }
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func clickedCreate(_ sender: BaseButton) {
        viewModel.save { [weak self] error in
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

extension TipFormViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == headerTextField {
            viewModel.tip.header = textField.text
        } else if textField == descriptionTextField {
            viewModel.tip.info = textField.text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
