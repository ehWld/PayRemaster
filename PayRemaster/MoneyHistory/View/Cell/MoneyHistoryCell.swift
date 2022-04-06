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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.cancelImage()
    }

    func configure(with item: History) {
        // profileImageView.setImage(with: item.imageUrl)
        nicknameLabel.text = "\(item.title)(\(item.subtitle))"
        dateLabel.text = item.date.formattedString("hh:dd")

        if item.amount >= 0 {
            amounLabel.text = "+" + item.amount.wonFormatted
            amounLabel.textColor = .blue
        } else {
            amounLabel.text = "-" + item.amount.wonFormatted
            amounLabel.textColor = .high_emphasis
        }
    }

}
