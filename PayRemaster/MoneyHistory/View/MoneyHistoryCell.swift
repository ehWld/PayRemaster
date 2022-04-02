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
    @IBOutlet weak var typeLabel: UILabel!
    
    static let identifier = "MoneyHistoryCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with transaction: Transaction) {
        nicknameLabel.text = transaction.title
        // amounLabel.text = String(transaction.amount)
    }

}
