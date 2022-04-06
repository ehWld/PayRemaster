//
//  TypeFilterCell.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/04/04.
//

import UIKit

class TypeFilterCell: UICollectionViewCell {
    
    static let identifier = "FilterCell"
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .medium_emphasis
        label.textAlignment = .center
        return label
    }()
    
    var intrinsicWidth: CGFloat {
        return titleLabel.intrinsicContentSize.width + widthInset * 2
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                contentView.backgroundColor = .grey700
                titleLabel.textColor = .inverse_high_emphasis
            } else {
                contentView.backgroundColor = .grey100
                titleLabel.textColor = .medium_emphasis
            }
        }
    }
    
    private let widthInset: CGFloat = 8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }

    func configure(with item: HistoryType) {
        titleLabel.text = item.title
        titleLabel.sizeToFit()
    }
    
    private func configureUI() {
        contentView.backgroundColor = .grey100
        layer.cornerRadius = 5
        self.clipsToBounds = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: widthInset),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -widthInset)
        ])
    }

}
