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

extension UIStackView {
    func removeArrangedSubviews() {
        arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }
}

extension UIView {
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

protocol LoaderPresentable {
    func presentLoader(_ present: Bool)
}

extension UIViewController: AlertPresentable {
    
    func presentAlert(message: String, completion: @escaping () -> ()) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"), style: .default, handler: { _ in completion() })
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    func presentAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"), style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}