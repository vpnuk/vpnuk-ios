//
//  ConnectionStatusView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 04.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import UIKit
import SnapKit

class ConnectionStatusView: UIView {
    
    private let appearance: Appearance
    var connectButtonAction: (() -> ())?
    
    var connectButtonEnabled: Bool {
        get { connectButton.isEnabled }
        set { connectButton.isEnabled = newValue }
    }
    
    private lazy var connectButton: UIButton =  {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(connectButtonTouched), for: .touchUpInside)
        return button
    }()
    
    private lazy var statusStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var containerView: UIStackView = {
        let buttonContainer = UIView()
        buttonContainer.addSubview(connectButton)
        connectButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
        }
        let view = UIStackView(arrangedSubviews: [statusStackView, buttonContainer])
        view.spacing = appearance.detailsAndButtonSpacing
        view.axis = .horizontal
        return view
    }()
    
    init(appearance: Appearance = Appearance()) {
        self.appearance = appearance
        super.init(frame: .zero)
        commonInit()
        update(with: .disconnected)
    }
    
    @objc private func connectButtonTouched() {
        connectButtonAction?()
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(appearance.containerViewInsets)
        }
    }
    
    private func setupSubviews() {
        addSubview(containerView)
        backgroundColor = appearance.bgColor
    }
    
    private func buildStatusView(forDetails details: ConnectionDetails) -> UIView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        if let ip = details.ip {
            stackView.addArrangedSubview(buildLine(title: "IP:", description: ip))
        }
        if let port = details.port {
            stackView.addArrangedSubview(buildLine(title: "Port:", description: "\(port)"))
        }
        if let socket = details.socketType {
            stackView.addArrangedSubview(buildLine(title: "Protocol:", description: socket))
        }
        return stackView
    }
    
    private func buildLine(title: String, description: String, descriptionColor: UIColor = .black) -> UIView {
        let ipSV = UIStackView()
        ipSV.axis = .horizontal
        ipSV.spacing = 3
        let titleLabel = UILabel()
        titleLabel.text = title
        
        let descLabel = UILabel()
        descLabel.text = description
        descLabel.textColor = descriptionColor
        
        ipSV.addArrangedSubview(titleLabel)
        ipSV.addArrangedSubview(descLabel)
        return ipSV
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with status: Status) {
        statusStackView.removeArrangedSubviews()
        switch status {
        case .connecting(let details):
            connectButton.setTitle("Disconnect", for: .normal)
            statusStackView.addArrangedSubview(buildLine(title: "Status:", description: "Connecting", descriptionColor: .systemOrange))
            statusStackView.addArrangedSubview(buildStatusView(forDetails: details))
        case .connected(let details):
            connectButton.setTitle("Disconnect", for: .normal)
            statusStackView.addArrangedSubview(buildLine(title: "Status:", description: "Connected", descriptionColor: .systemGreen))
            statusStackView.addArrangedSubview(buildStatusView(forDetails: details))
        case .disconnected:
            connectButton.setTitle("Connect", for: .normal)
            statusStackView.addArrangedSubview(buildLine(title: "Status:", description: "Disconnected", descriptionColor: .systemRed))
        case .disconnecting:
            connectButton.setTitle("Disconnecting", for: .normal)
            statusStackView.addArrangedSubview(buildLine(title: "Status:", description: "Disconnecting", descriptionColor: .systemOrange))
        }
    }
}

extension ConnectionStatusView {
    enum Status {
        case connecting(details: ConnectionDetails)
        case connected(details: ConnectionDetails)
        case disconnected
        case disconnecting
    }
    
    struct ConnectionDetails {
        let ip: String?
        let port: UInt16?
        let socketType: String?
    }
    
    struct Appearance {
        let bgColor: UIColor = .yellow
        let containerViewInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let detailsAndButtonSpacing: CGFloat = 30
    }
}
