//
//  ServerPickerViewController.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 05.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import UIKit

protocol ServerPickerViewModelProtocol {
    var selectedType: ServerType { get }
    var servers: [ServerType : [ServerEntity]] { get }
    func isConnected(toServer server: ServerEntity) -> Bool
    func select(server: ServerEntity)
}

class ServerPickerViewController: UIViewController {
    private let viewModel: ServerPickerViewModelProtocol
    
    
    private lazy var contentView = UIView()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        return UISegmentedControl(frame: .zero)
    }()
    
    private lazy var tableView: UITableView = {
        let tableview = UITableView()
        tableview.register(UINib(nibName: String(describing: ServerItemTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ServerItemTableViewCell.self))
        tableview.delegate = self
        tableview.dataSource = self
        return tableview
    }()
    
    override func loadView() {
        view = contentView
    }
    
    init(viewModel: ServerPickerViewModelProtocol) {
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
        // Do any additional setup after loading the view.
    }
    

    private func setupView() {
        view.addSubview(containerStackView)
        containerStackView.addArrangedSubview(segmentedControl)
        containerStackView.addArrangedSubview(tableView)
        containerStackView.makeEdgesEqualToSuperview()
    }
    
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

}

extension ServerPickerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.servers[viewModel.selectedType]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ServerItemTableViewCell.self), for: indexPath) as! ServerItemTableViewCell
        if let server = viewModel.servers[viewModel.selectedType]?[indexPath.row] {
            cell.update(withServerEntity: server, isConnected: viewModel.isConnected(toServer: server))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let server = viewModel.servers[viewModel.selectedType]?[indexPath.row] {
            viewModel.select(server: server)
        }
    }
    
    
}
