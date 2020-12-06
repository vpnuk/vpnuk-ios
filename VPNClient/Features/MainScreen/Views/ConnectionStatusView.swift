//
//  ConnectionStatusView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 04.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import UIKit
import SnapKit

protocol ConnectionStatusViewProtocol: AnyObject {
    var connectButtonAction: Action? { get set }
    func update(with status: ConnectionStatusView.Model)
}

class ConnectionStatusView: UIView, ConnectionStatusViewProtocol {
    
    private let appearance: Appearance
    var connectButtonAction: Action?
    
    var connectButtonEnabled: Bool {
        get { connectButton.isEnabled }
        set { connectButton.isEnabled = newValue }
    }
    
    private lazy var connectButton: UIButton =  {
        let button = UIButton()
        button.layer.cornerRadius = 25
        
        button.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = .init(width: 0, height: 2)
        button.layer.shadowRadius = 2
        
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        
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
            make.height.equalTo(50)
        }
        
        let spacer1 = UIView()
        let spacer2 = UIView()
       
        let statusContainer = UIStackView(
            arrangedSubviews: [
                spacer1,
                statusStackView,
                spacer2
            ]
        )
        spacer1.snp.makeConstraints { make in
            make.height.equalTo(spacer2.snp.height)
        }
        
        statusContainer.axis = .vertical
        let view = UIStackView(arrangedSubviews: [statusContainer, buttonContainer])
        view.spacing = appearance.detailsAndButtonSpacing
        view.axis = .horizontal
        return view
    }()
    
    private lazy var separatorView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        return view
    }()
    
    init(appearance: Appearance = Appearance()) {
        self.appearance = appearance
        super.init(frame: .zero)
        commonInit()
        update(with: .init(status: .disconnected))
    }
    
    @objc
    private func connectButtonTouched() {
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
        
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.right.top.equalToSuperview()
        }
    }
    
    private func setupSubviews() {
        addSubview(containerView)
        addSubview(separatorView)
        backgroundColor = appearance.bgColor
        
        layer.shadowColor = UIColor.black.withAlphaComponent(0.04).cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = .init(width: 0, height: -3)
        layer.shadowRadius = 1
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
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        
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
    
    func update(with model: Model) {
        statusStackView.removeArrangedSubviews()
        switch model.status {
        case .connecting(let details):
            connectButton.setTitle("Disconnect", for: .normal)
            statusStackView.addArrangedSubview(buildLine(title: "Status:", description: "Connecting", descriptionColor: appearance.connectingStatusColor))
            statusStackView.addArrangedSubview(buildStatusView(forDetails: details))
            connectButton.backgroundColor = appearance.disconnectButtonColor
        case .connected(let details):
            connectButton.setTitle("Disconnect", for: .normal)
            statusStackView.addArrangedSubview(buildLine(title: "Status:", description: "Connected", descriptionColor: appearance.connectedStatusColor))
            statusStackView.addArrangedSubview(buildStatusView(forDetails: details))
            connectButton.backgroundColor = appearance.disconnectButtonColor
        case .disconnected:
            connectButton.setTitle("Connect", for: .normal)
            statusStackView.addArrangedSubview(buildLine(title: "Status:", description: "Disconnected", descriptionColor: appearance.disconnectedStatusColor))
            connectButton.backgroundColor = appearance.connectButtonColor
        case .disconnecting:
            connectButton.setTitle("Disconnecting", for: .normal)
            statusStackView.addArrangedSubview(buildLine(title: "Status:", description: "Disconnecting", descriptionColor: appearance.disconnectingStatusColor))
            connectButton.backgroundColor = appearance.disconnectButtonColor
        }
    }
}

extension ConnectionStatusView {
    struct Model {
        let status: Status
        let isInteractionsEnabled: Bool
        
        init(status: ConnectionStatusView.Status, isInteractionsEnabled: Bool = true) {
            self.status = status
            self.isInteractionsEnabled = isInteractionsEnabled
        }
    }
    
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
        let bgColor: UIColor = .white
        
        let disconnectButtonColor: UIColor = .systemOrange
        let connectButtonColor: UIColor = Style.Color.blueColor
        
        let disconnectingStatusColor: UIColor = .systemOrange
        let connectingStatusColor: UIColor = .systemOrange
        let connectedStatusColor: UIColor = .systemGreen
        let disconnectedStatusColor: UIColor = .systemRed
        
        let containerViewInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let detailsAndButtonSpacing: CGFloat = 30
    }
}
