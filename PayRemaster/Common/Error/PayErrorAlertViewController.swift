//
//  PayErrorAlertViewController.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/04/07.
//

import UIKit

class PayErrorAlertViewController: UIViewController {
    
    // MARK: - Subviews
    
    @IBOutlet weak var alertView: UIView!
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
        self.alertView.transform = CGAffineTransform(translationX: 0.0, y: -(self.view.frame.height - self.alertView.frame.height) / 2.0)
        print(self.view.frame.height)
        print(self.alertView.frame.height)
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) { [weak self] in
            guard let self = self else { return }
            self.alertView.transform = .identity
            self.alertView.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) { [weak self] in
            guard let self = self else { return }
            self.alertView.transform = CGAffineTransform(translationX: 0.0, y: (self.view.frame.height - self.alertView.frame.height) / 2.0)
            self.alertView.isHidden = true
        }
    }
    
    @IBAction func buttonDidTap(_ sender: Any) {
        if let action = buttonAction { action() }
        self.dismiss(animated: false, completion: nil)
    }
    
    private func configureUI() {
        titleLabel.text = titleText
        subtitleLabel.text = subtitleText
        imageView.image = image
        button.setTitle(buttonTitle, for: .normal)
    }
    
}

extension PayErrorAlertViewController {
    static func instantiate(title: String? = nil,
                            subtitle: String? = nil,
                            image: UIImage? = nil,
                            buttonTitle: String? = nil,
                            action: (() -> Void)? = nil
    ) -> PayErrorAlertViewController {
        return UIStoryboard(name: "PayErrorAlertView", bundle: nil).instantiateViewController(identifier: "PayErrorAlertView") { coder in
            PayErrorAlertViewController(coder: coder,
                                        title: title,
                                        subtitle: subtitle,
                                        image: image,
                                        buttonTitle: buttonTitle,
                                        action: action
            )
        }
    }
}
