//
//  TipTableViewCell.swift
//  EcoClean
//
//  Created by Karen Khachatryan on 04.12.24.
//

import UIKit

class TipTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor.black.cgColor
        headerLabel.font = .regular(size: 18)
        infoLabel.font = .regular(size: 16)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(tip: TipModel) {
        headerLabel.text = tip.header
        infoLabel.text = tip.info
    }
    
}
