//
//  UIView+Extensions.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 05.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import MBProgressHUD

extension UIStackView {
    func removeArrangedSubviews() {
        arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }
}

extension UIView {
    
    func makeDefaultShadowAndCorners() {
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = .init(width: 0, height: 3)
        layer.shadowRadius = 5
    }
    
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach(addSubview(_:))
    }
    
    func contained(with insets: UIEdgeInsets) -> UIView {
        let container = UIView()
        container.addSubview(self)
        makeEdgesEqual(to: insets)
        return container
    }
    
    func makeEdgesEqual(to edges: UIEdgeInsets) {
        snp.makeConstraints { make in
            make.edges.equalTo(edges)
        }
    }
    
    func makeEdgesEqualToSuperview() {
        snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @discardableResult   // 1
    func fromNib<T : UIView>() -> T? {   // 2
        guard let contentView = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {    // 3
            // xib not loaded, or its top view is of the wrong type
            return nil
        }
        self.addSubview(contentView)     // 4
        contentView.translatesAutoresizingMaskIntoConstraints = false   // 5
        contentView.makeEdgesEqualToSuperview()   // 6
        return contentView   // 7
    }
    
    func removeSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
}

protocol AlertPresentable {
    func presentAlert(message: String, completion: @escaping () -> ())
    func presentAlert(message: String)
}

protocol LoaderPresentable: AnyObject {
    func setLoading(_ present: Bool)
}

extension LoaderPresentable {
    func showAndHideLoader(after seconds: TimeInterval) {
        self.setLoading(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [weak self] in
            self?.setLoading(false)
        }
    }
}
extension UIViewController: LoaderPresentable {
    func setLoading(_ present: Bool) {
        if present {
            MBProgressHUD.showAdded(to: view, animated: true)
        } else {
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
}

extension UIView: LoaderPresentable {
    func setLoading(_ present: Bool) {
        if present {
            MBProgressHUD.showAdded(to: self, animated: true)
        } else {
            MBProgressHUD.hide(for: self, animated: true)
        }
    }
}

extension UIViewController: AlertPresentable {
    
    func presentAlert(message: String, completion: @escaping () -> ()) {
        let alertController = AlertUtils.buildOkAlert(with: message, completion: completion)
        present(alertController, animated: true)
    }
    
    func presentAlert(message: String) {
        presentAlert(message: message, completion: {})
    }
}
