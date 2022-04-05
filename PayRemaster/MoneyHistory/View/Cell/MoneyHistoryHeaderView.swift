//
//  MoneyHistoryHeaderView.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/03/31.
//

import UIKit

class MoneyHistoryHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "MoneyHistoryHeaderView"
    static let nib = UINib(nibName: "MoneyHistoryHeaderView", bundle: nil)

    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with title: String) {
        dateLabel.text = title
    }

}
