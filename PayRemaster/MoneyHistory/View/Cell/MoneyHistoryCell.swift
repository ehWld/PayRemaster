//
//  MoneyHistoryCell.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/03/30.
//

import UIKit

class MoneyHistoryCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var amounLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    static let identifier = "MoneyHistoryCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with item: History) {
        nicknameLabel.text = "\(item.title)(\(item.subtitle))"
        dateLabel.text = item.date.formattedString("hh:dd")
        // FIXME: - 돈 표기법 그걸로
        amounLabel.text = "\(item.amount)원"
    }

}
