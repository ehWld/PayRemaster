//
//  PayErrorViewController.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/04/09.
//

import UIKit

class PayErrorViewController: UIViewController {
    
    // MARK: - Subviews
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    // MARK: - Properties
    
    private var titleText: String?
    private var subtitleText: String?
    private var image: UIImage?
    private var buttonTitle: String?
    private var buttonAction: (() -> Void)?
    
    init?(coder: NSCoder, title: String?, subtitle: String?, image: UIImage?, buttonTitle: String?, action: (() -> Void)?) {
        super.init(coder: coder)
        self.titleText = title
        self.subtitleText = subtitle
        self.image = image
        self.buttonTitle = buttonTitle
        self.buttonAction = action
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.isHidden = true
        UIView.animate(withDuration: 0.1, delay: 0.0) { [weak self] in
            self?.view.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.1, delay: 0.0) { [weak self] in
            self?.view.isHidden = true
        }
    }
    
    private func configureUI() {
        titleLabel.text = titleText
        subtitleLabel.text = subtitleText
        imageView.image = image
        button.setTitle(buttonTitle, for: .normal)
    }
    
    @IBAction func buttonDidTap(_ sender: Any) {
        if let action = buttonAction { action() }
    }
    
}

extension PayErrorViewController {
    static func instantiate(title: String? = nil,
                            subtitle: String? = nil,
                            image: UIImage? = nil,
                            buttonTitle: String? = nil,
                            action: (() -> Void)? = nil
    ) -> PayErrorViewController {
        return UIStoryboard(name: "PayErrorView", bundle: nil).instantiateViewController(identifier: "PayErrorView") { coder in
            PayErrorViewController(coder: coder,
                                        title: title,
                                        subtitle: subtitle,
                                        image: image,
                                        buttonTitle: buttonTitle,
                                        action: action
            )
        }
    }
}
