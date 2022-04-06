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
    var minDate = Date() // 2022 01
    var maxDate = Date() // 인자로 넘겨받아
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
//        NSLayoutConstraint.activate([
//            contentView.topAnchor.constraint(equalTo: self.topAnchor),
//            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
//        ])
    }
    
    private func configureUI() {
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    private func bind() {
        $currentDate
            .sink { [weak self] date in
                self?.dateLabel.text = date.formattedString("YYYY년 M월")
                self?.configureButtons()
            }
            .store(in: &cancellables)
    }
    
    private func configureButtons() {
        if isEndOfDate(currentDate, maxDate) {
            rightButton.isEnabled = false
        } else {
            rightButton.isEnabled = true
        }
        
        if isEndOfDate(minDate, currentDate) {
            leftButton.isEnabled = false
        } else {
            rightButton.isEnabled = true
        }
    }
    
    // minDate는 lhs에, maxDate는 rhs에 놓고 비교
    private func isEndOfDate(_ lhs: Date, _ rhs: Date) -> Bool {
        return lhs.year * 100 + lhs.month >= rhs.year * 100 + rhs.month
    }
    
    // MARK: - Actions

    @IBAction func leftButtonPushed(_ sender: Any) {
    }
    @IBAction func rightButtonPushed(_ sender: Any) {
    }
    //    @IBAction func leftButtonPushed(_ sender: Any) {
//        currentDate = currentDate.advanced(by: .month, value: -1)
//    }
//
//    @IBAction func rightButtonPushed(_ sender: Any) {
//        currentDate = currentDate.advanced(by: .month, value: 1)
//    }
//
}
