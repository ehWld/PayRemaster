//
//  UIViewController+Extension.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/04/09.
//

import UIKit

extension UIViewController {
    func showPayErrorAlert(_ error: PayError, action: (() -> Void)? = nil) {
        var title: String?
        var subtitle: String?
        var image: UIImage?
        var buttonTitle: String?
        var buttonAction: (() -> Void)?
        var viewController: UIViewController
        
        switch error {
        case .forceUpdate:
            title = "앱을 업데이트해주세요."
            subtitle = "원활한 서비스 이용을 위한 최신 버전으로 업데이트해주세요."
            image = UIImage(named: "app_update")
            buttonTitle = "스토어로 이동"
            buttonAction = {
                if UIApplication.shared.canOpenURL(URL.AppStore.payApp) {
                    UIApplication.shared.open(URL.AppStore.payApp, options: [:], completionHandler: nil)
                }
            }
        case .inspectionTime:
            title = "서비스를 점검하고 있습니다."
            subtitle = "원활한 서비스 제공을 위해 노력중이니 조금만 기다려주세요."
            image = UIImage(named: "common_error")
            image?.withTintColor(.red)
            buttonTitle = "확인"
            buttonAction = {
                if let action = action { action() }
                self.dismiss(animated: false, completion: nil)
            }
        case .internalServerError:
            title = "잠시 연결이 늦어지고 있습니다."
            subtitle = "조금 뒤 다시 이용해주세요."
            image = UIImage(named: "common_error")
            image?.withTintColor(.red)
            buttonTitle = "확인"
            buttonAction = {
                if let action = action { action() }
                self.dismiss(animated: false, completion: nil)
            }
        default:
            title = "연결상태가 좋지 않습니다."
            subtitle = "조금 뒤 다시 이용해주세요."
            image = UIImage(named: "network_error")
            buttonTitle = "다시 시도"
        }
        
        switch error {
        case .forceUpdate, .inspectionTime, .internalServerError:
            viewController = PayErrorViewController.instantiate(title: title,
                                                                subtitle: subtitle,
                                                                image: image,
                                                                buttonTitle: buttonTitle,
                                                                action: buttonAction)
        default:
            viewController = PayErrorAlertViewController.instantiate(title: title,
                                                                     subtitle: subtitle,
                                                                     image: image,
                                                                     buttonTitle: buttonTitle,
                                                                     action: buttonAction)
        }
        
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: false, completion: nil)
    }
}
