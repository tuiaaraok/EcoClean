//
//  TipsViewController.swift
//  EcoClean
//
//  Created by Karen Khachatryan on 04.12.24.
//

import UIKit
import Combine

class TipsViewController: UIViewController {

    @IBOutlet weak var tipsTableView: UITableView!
    private let viewModel = TipsViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
        viewModel.fetchData()
    }
    
    func setupUI() {
        setNaviagtionBackButton()
        setNavigationTitle(title: "Tips")
        tipsTableView.register(UINib(nibName: "TipTableViewCell", bundle: nil), forCellReuseIdentifier: "TipTableViewCell")
        tipsTableView.delegate = self
        tipsTableView.dataSource = self
    }
    
    func subscribe() {
        viewModel.$tips
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.tipsTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    func openTipForm() {
        let tipFormVC = TipFormViewController(nibName: "TipFormViewController", bundle: nil)
        tipFormVC.completion = { [weak self] in
            if let self = self {
                self.viewModel.fetchData()
            }
        }
        self.navigationController?.pushViewController(tipFormVC, animated: true)
    }
    
    @IBAction func clickedAddTip(_ sender: UIButton) {
        openTipForm()
    }
    
    deinit {
        viewModel.clear()
    }
}

extension TipsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.tips.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TipTableViewCell", for: indexPath) as! TipTableViewCell
        cell.configure(tip: viewModel.tips[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        28
    }
}
