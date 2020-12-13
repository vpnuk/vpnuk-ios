//
//  SubscriptionsListViewController.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 05.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

class SubscriptionsListViewController: UIViewController {
    private let subscriptions: [SubscriptionDTO]
    private let subscriptionPickedAction: SubscriptionPickedAction
    private let initiallySelectedSubscription: SubscriptionVPNAccount?
    
    private lazy var contentView = UIView()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var tableView: UITableView = {
        let tableview = UITableView()
        tableview.register(SubscriptionTableViewCell.self, forCellReuseIdentifier: String(describing: SubscriptionTableViewCell.self))
        tableview.delegate = self
        tableview.dataSource = self
        tableview.tableFooterView = UIView()
        return tableview
    }()
    
    private lazy var navbar: UINavigationBar = {
        let navbar = UINavigationBar()
        let item = UINavigationItem(title: "Choose subscription")
        item.setLeftBarButton(.init(title: "Close", style: .done, target: self, action: #selector(closeButtonTouched)), animated: false)
        
        navbar.setItems([item], animated: false)
        return navbar
    }()
    
    override func loadView() {
        view = contentView
    }
    
    init(
        subscriptions: [SubscriptionDTO],
        subscriptionPickedAction: @escaping SubscriptionPickedAction,
        initiallySelectedSubscription: SubscriptionVPNAccount? = nil
    ) {
        self.subscriptions = subscriptions
        self.subscriptionPickedAction = subscriptionPickedAction
        self.initiallySelectedSubscription = initiallySelectedSubscription
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
        dismissView()
    }
    
    private func isEqual(lhs: SubscriptionDTO?, rhs: SubscriptionDTO?) -> Bool {
        guard let lhs = lhs, let rhs = rhs else {
            return false
        }
        return lhs.id == rhs.id
    }
    
    func openVPNAccountsList(forSubscription subscription: SubscriptionDTO) {
        let initialAccount = isEqual(lhs: subscription, rhs: initiallySelectedSubscription?.subscription) ? initiallySelectedSubscription?.vpnAccount : nil
        let controller = VPNAccountsListViewController(
            subscription: subscription,
            subscriptionPickedAction: { [weak self] data in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: { self.subscriptionPickedAction(data)})
            }, initiallySelectedVPNAccount: initialAccount
        )
        present(controller, animated: true)
    }
}

extension SubscriptionsListViewController {
    func update() {
        tableView.reloadData()
    }
    
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SubscriptionsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscriptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SubscriptionTableViewCell.self), for: indexPath) as! SubscriptionTableViewCell
        
        let subscription = subscriptions[indexPath.row]
        
        cell.update(
            model: .init(
                subscriptionModel: .init(
                    title: subscription.productName,
                    vpnAccountsQuantity: subscription.quantity,
                    maxSessions: subscription.sessions,
                    subscriptionStatus: subscription.status,
                    periodMonths: subscription.period,
                    trialEnd: subscription.trialEndDate,
                    subscriptionType: subscription.type,
                    renewSubscriptionModel: getRenewSubscriptionModel(for: subscription)
                )
            )
        )
        return cell
    }
    
    private func getRenewSubscriptionModel(
        for subscription: SubscriptionDTO
    ) -> PickedSubscriptionInfoView.RenewSubscriptionModel? {
        let model = RenewSubscriptionButtonModelBuilder().build(for: subscription, router: self)
        return model
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let subscription = subscriptions[indexPath.row]
        if isEqual(lhs: subscription, rhs: initiallySelectedSubscription?.subscription) {
            cell.setSelected(true, animated: false)
        } else {
            cell.setSelected(false, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let subscription = subscriptions[indexPath.row]
        openVPNAccountsList(forSubscription: subscription)
    }
}

extension SubscriptionsListViewController: RenewSubscriptionButtonRouterProtocol {
    func presentOkCancelAlert(withText text: String, okAction: @escaping Action) {
        let alert = AlertUtils.buildOkCancelAlert(with: text, okAction: { okAction() })
        present(alert, animated: true)
    }
    
    func openRenewSubscriptionScreen(
        for subscription: SubscriptionDTO
    ) {
        let controller = RenewPendingSubscriptionFactory().create(
            subscriptionToRenew: subscription,
            reloadSubscriptionsAction: {}
        )
        present(controller, animated: true, completion: nil)
    }
}
