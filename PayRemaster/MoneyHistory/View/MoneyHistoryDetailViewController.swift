//
//  MoneyHistoryDetailViewController.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/04/05.
//

import UIKit

class MoneyHistoryDetailViewController: UIViewController {
    
    // MARK: - Subviews
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountTitleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Setup
    
    private func configureUI() {
        title = "상세내역"
        navigationItem.largeTitleDisplayMode = .never
    }

    @IBAction func confirmButtonPushed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension MoneyHistoryDetailViewController {
    static func instantiate() -> MoneyHistoryDetailViewController {
        return UIStoryboard(name: "MoneyHistoryDetail", bundle: nil).instantiateViewController(withIdentifier: "MoneyHistoryDetail") as! MoneyHistoryDetailViewController
    }
}
