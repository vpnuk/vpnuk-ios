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
