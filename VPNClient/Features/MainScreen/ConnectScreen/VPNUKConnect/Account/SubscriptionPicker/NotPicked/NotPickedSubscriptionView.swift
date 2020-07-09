//
//  NotPickedSubscriptionView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 05.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

class NotPickedSubscriptionView: UIView {
    private var tapAction: Action?
    
    private lazy var notPickedLabel: UILabel = {
          let label = UILabel()
          label.numberOfLines = 0
          label.textAlignment = .center
          return label
      }()
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: Model) {
        tapAction = model.tapAction
        notPickedLabel.text = model.title
    }
    
    private func setupSubviews() {
        backgroundColor = .white
        addSubview(notPickedLabel)
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tap)
        makeDefaultShadowAndCorners()
    }
    
    @objc
    private func viewTapped() {
        tapAction?()
    }
    
    private func setupConstraints() {
        notPickedLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
}

extension NotPickedSubscriptionView {
    struct Model {
        let title: String
        let tapAction: Action
    }
}
