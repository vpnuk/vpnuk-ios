//
//  ServerPickerNotPickedView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 10.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import UIKit

class ServerPickerNotPickedView: UIView {
    private lazy var pickServerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pickServer")
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Pick a VPN server...", comment: "")
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            pickServerImageView,
            label,
        ])
        stackView.axis = .horizontal
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
    
    
    private func setupSubviews() {
        addSubview(containerStackView)
    }
    
    private func setupConstraints() {
        containerStackView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
        }
    }
    
    
}
