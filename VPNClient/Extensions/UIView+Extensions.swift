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
}
