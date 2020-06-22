//
//  ServerPickerViewController.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 05.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import UIKit

protocol ServerPickerListViewProtocol: AnyObject {
    func update()
    func dismissView()
}

class ServerPickerListViewController: UIViewController {
    private let viewModel: ServerPickerListViewModelProtocol
    private lazy var contentView = UIView()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(frame: .zero)
        control.addTarget(self, action: #selector(serverTypeUpdated), for: .valueChanged)
        return control
    }()
    
    private lazy var tableView: UITableView = {
        let tableview = UITableView()
        tableview.register(UINib(nibName: String(describing: ServerItemTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ServerItemTableViewCell.self))
        tableview.delegate = self
        tableview.dataSource = self
        return tableview
    }()
    
    private lazy var navbar: UINavigationBar = {
        let navbar = UINavigationBar()
        let item = UINavigationItem(title: "Choose server")
        item.setLeftBarButton(.init(title: "Close", style: .done, target: self, action: #selector(closeButtonTouched)), animated: false)
        
        navbar.setItems([item], animated: false)
        return navbar
    }()
    
    override func loadView() {
        view = contentView
    }
    
    init(viewModel: ServerPickerListViewModelProtocol) {
        self.viewModel = viewModel
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
        containerStackView.addArrangedSubview(segmentedControl)
        containerStackView.addArrangedSubview(tableView)
        
        tableView.rowHeight = 120
        tableView.estimatedRowHeight = 120
        
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
    private func serverTypeUpdated() {
        let types = viewModel.servers.keys.sorted()
        let newSelectedType = types[segmentedControl.selectedSegmentIndex]
        viewModel.selectedType = newSelectedType
    }
    
    @objc
    private func closeButtonTouched() {
        dismissView()
    }

}

extension ServerPickerListViewController: ServerPickerListViewProtocol {
    func update() {
        segmentedControl.removeAllSegments()
        let types = viewModel.servers.keys.sorted()
        for type in types.reversed() {
            segmentedControl.insertSegment(withTitle: type.title, at: 0, animated: false)
        }
        if let selectedIndex = types.firstIndex(of: viewModel.selectedType) {
            segmentedControl.selectedSegmentIndex = selectedIndex
        }
        
        tableView.reloadData()
    }
    
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ServerPickerListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.servers[viewModel.selectedType]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selectedType = viewModel.selectedType
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ServerItemTableViewCell.self), for: indexPath) as! ServerItemTableViewCell
        if let server = viewModel.servers[selectedType]?[indexPath.row] {
            cell.update(
                withServerEntity: server,
                isConnected: viewModel.isConnected(toServerAt: .init(type: selectedType, index: indexPath.row))
            )
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.select(serverAt: .init(type: viewModel.selectedType, index: indexPath.row))
    }
}
