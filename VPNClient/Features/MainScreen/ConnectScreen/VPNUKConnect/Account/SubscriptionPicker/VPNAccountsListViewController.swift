//
//  VPNAccountsListViewController.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 05.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import Foundation
import UIKit

class VPNAccountsListViewController: UIViewController {
    private let subscription: SubscriptionDTO
    private let subscriptionPickedAction: SubscriptionPickedAction
    private let initiallySelectedVPNAccount: VPNAccountDTO?
    
    private lazy var contentView = UIView()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var tableView: UITableView = {
        let tableview = UITableView()
        tableview.register(VPNAccountTableViewCell.self, forCellReuseIdentifier: String(describing: VPNAccountTableViewCell.self))
        tableview.delegate = self
        tableview.dataSource = self
        tableview.tableFooterView = UIView()
        return tableview
    }()
    
    private lazy var navbar: UINavigationBar = {
        let navbar = UINavigationBar()
        let item = UINavigationItem(title: "Choose VPN account")
        item.setLeftBarButton(.init(title: "Close", style: .done, target: self, action: #selector(closeButtonTouched)), animated: false)
        
        navbar.setItems([item], animated: false)
        return navbar
    }()
    
    override func loadView() {
        view = contentView
    }
    
    init(subscription: SubscriptionDTO, subscriptionPickedAction: @escaping SubscriptionPickedAction, initiallySelectedVPNAccount: VPNAccountDTO? = nil) {
        self.subscription = subscription
        self.subscriptionPickedAction = subscriptionPickedAction
        self.initiallySelectedVPNAccount = initiallySelectedVPNAccount
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        update()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(containerStackView)
        view.addSubview(navbar)
        containerStackView.addArrangedSubview(tableView)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        navbar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints { make in
            make.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(navbar.snp.bottom)
        }
    }
    
    @objc
    private func closeButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
    
    func accountPicked(account: VPNAccountDTO) {
        dismiss(animated: false, completion: {
            self.subscriptionPickedAction(.init(subscription: self.subscription, vpnAccount: account))
        })
    }
}

extension VPNAccountsListViewController {
    func update() {
        tableView.reloadData()
    }

}

extension VPNAccountsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscription.vpnAccounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: VPNAccountTableViewCell.self), for: indexPath) as! VPNAccountTableViewCell
        
        let account = subscription.vpnAccounts[indexPath.row]
        
        let serverModel: PickedSubscriptionDedicatedServerView.Model?
        if let server = account.server{
            serverModel = .init(
                title: nil,
                ip: server.ip,
                uniqueUserIp: account.uniqueUserIp,
                location: server.location
            )
        } else {
            serverModel = nil
        }
        
        let info: String?
        switch subscription.type {
        case .dedicated, .oneToOne:
            info = NSLocalizedString("With this account you can connect to your dedicated server and all shared servers.", comment: "")
        case .shared:
            info = nil
        }
        
        cell.update(
            model: .init(
                vpnAccountModel: .init(
                    username: account.username,
                    password: account.password,
                    info: info
                ),
                dedicatedServerModel: serverModel
            )
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let account = subscription.vpnAccounts[indexPath.row]
        if account.username == initiallySelectedVPNAccount?.username {
            cell.setSelected(true, animated: false)
        } else {
            cell.setSelected(false, animated: false)
        }
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let account = subscription.vpnAccounts[indexPath.row]
        accountPicked(account: account)
    }
}

