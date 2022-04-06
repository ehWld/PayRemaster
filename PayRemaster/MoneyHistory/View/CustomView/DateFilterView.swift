//
//  DateFilterView.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/04/06.
//

import UIKit
import Combine

class DateFilterView: UIView {

    // MARK: - Subviews

    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    
    var contentView: UIView!
    
    // MARK: - Properties
    
    @Published var currentDate = Date()
    var minDate = Date()
    var maxDate = Date()
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        super.init(frame: .zero)
        configureNib()
        configureUI()
        bind()
    }
    
    convenience init(from minDate: Date, to maxDate: Date) {
        self.init()
        self.minDate = minDate
        self.maxDate = maxDate
        self.currentDate = maxDate
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureNib()
        configureUI()
        bind()
    }
    
    // MARK: - Setup
    
    private func configureNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "DateFilterView", bundle: bundle)
        contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        
        contentView.frame = self.bounds
        addSubview(contentView)
    }
    
    private func configureUI() {
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: 3)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        minDate = dateFormatter.date(from: "2022-01") ?? Date()
        configureButtons(with: currentDate)
    }
    
    private func bind() {
        $currentDate
            .sink { [weak self] date in
                self?.dateLabel.text = date.formattedString("yyyy년 M월")
                self?.configureButtons(with: date)
            }
            .store(in: &cancellables)
    }
    
    private func configureButtons(with date: Date) {
        if isEndOfDate(date, maxDate) {
            rightButton.isEnabled = false
        } else {
            rightButton.isEnabled = true
        }

        if isEndOfDate(minDate, date) {
            leftButton.isEnabled = false
        } else {
            leftButton.isEnabled = true
        }
    }
    
    // minDate는 lhs에, maxDate는 rhs에 놓고 비교
    private func isEndOfDate(_ lhs: Date, _ rhs: Date) -> Bool {
        return lhs.year * 100 + lhs.month >= rhs.year * 100 + rhs.month
    }
    
    // MARK: - Actions

    @IBAction func leftButtonPushed(_ sender: Any) {
        currentDate = currentDate.advanced(by: .month, value: -1) ?? Date()
    }
    
    @IBAction func rightButtonPushed(_ sender: Any) {
        currentDate = currentDate.advanced(by: .month, value: 1) ?? Date()
    }

}
