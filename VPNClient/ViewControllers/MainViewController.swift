//
//  MainViewController.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.10.2019.
//  Copyright © 2019 VPNUK. All rights reserved.
//

import UIKit
import NetworkExtension

class MainViewController: UIViewController {

    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var serversTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var connectionStatusLabel: UILabel!
    @IBOutlet weak var serversListTableView: UITableView!
    @IBOutlet weak var savePasswordButton: UIButton!
    
    @IBAction func showAllServersListTouched(_ sender: UIButton) {
    }
    weak var serversListVC: ServerListViewController?
    
    @IBAction func savePasswordTouched(_ sender: UIButton) {
        savePasswordButton.isSelected = !savePasswordButton.isSelected
        vm.storeCredentials = savePasswordButton.isSelected
        updateSavePasswordSelector()
    }
    
    @IBAction func serverTypeChanged(_ sender: UISegmentedControl) {
        vm.serversType = sender.selectedSegmentIndex == 0 ? .shared : .dedicated
    }
    
    @IBAction func connectTouched(_ sender: UIButton) {
        
        
        vm.connectTouched()
    }
    var vm: MainViewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        vm.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func setupViews() {
//        usernameTextField.text = "stan"
//        passwordTextField.text = "stan"
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        vm.view = self
        serversTypeSegmentedControl.selectedSegmentIndex = vm.serversType == .shared ? 0 : 1
        serversListTableView.delegate = self
        serversListTableView.dataSource = self
        connectionStatusLabel.text = "Disconnected"
        connectionStatusLabel.textColor = .red
        updateSavePasswordSelector()
    }
    
    private func updateSavePasswordSelector() {
        savePasswordButton.isSelected = vm.storeCredentials
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showServerListSegue", let vc = segue.destination as? ServerListViewController {
            serversListVC = vc
            vc.serversType = vm.serversType
            vc.servers = vm.serverListController.fetchedObjects ?? []
            vc.delegate = self
        }
    }
}

extension MainViewController: MainView {
    func showError(description: String) {
        let ac = UIAlertController(title: nil, message: description, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    func serverListUpdated() {
        serversListTableView.reloadData()
        serversListVC?.servers = vm.serverListController.fetchedObjects ?? []
    }
    
    func statusUpdated(newStatus status: NEVPNStatus) {
        switch status {
        case .connecting:
            connectButton.setTitle("Disconnect", for: .normal)
            if let ip = vm.serverIP, let port = vm.port, let proto = vm.socketType {
                connectionStatusLabel.text = "Connecting to \(ip):\(port), protocol: \(proto.rawValue) ..."
            } else {
                connectionStatusLabel.text = "Connecting..."
            }
            connectionStatusLabel.textColor = .orange
        case .connected:
            connectButton.setTitle("Disconnect", for: .normal)
            if let ip = vm.serverIP, let port = vm.port, let proto = vm.socketType {
                connectionStatusLabel.text = "Connected to \(ip):\(port), protocol: \(proto.rawValue)"
            } else {
                connectionStatusLabel.text = "Connected"
            }
            connectionStatusLabel.textColor = .systemGreen
        case .disconnected:
            connectButton.setTitle("Connect", for: .normal)
            connectionStatusLabel.text = "Disconnected"
            connectionStatusLabel.textColor = .red
        case .disconnecting:
            connectButton.setTitle("Disconnecting", for: .normal)
            connectionStatusLabel.text = "Disconnecting..."
            connectionStatusLabel.textColor = .orange
        default:
            break
        }
        serverListUpdated()
    }
    
    var username: String? {
        get {
            return usernameTextField.text
        }
        set {
            usernameTextField.text = newValue
        }
    }
    
    var password: String? {
        get {
            return passwordTextField.text
        }
        set {
            passwordTextField.text = newValue
        }
    }
    
}

extension MainViewController: ServerListDelegate {
    
    var selectedServer: ServerEntity? {
        return vm.selectedServer
    }
    
    func serverPicked(atIndexPath indexPath: IndexPath, server: ServerEntity) {
        vm.select(server: server)
        serversListTableView.reloadData()
        let count = vm.serverListController.fetchedObjects?.count ?? 0
        if indexPath.row < count {
            serversListTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}

extension MainViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if vm.storeCredentials {
            vm.storeCredentials = false
            updateSavePasswordSelector()
        }
        return true
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func isConnected(toServer server: ServerEntity) -> Bool {
        return vm.isConnected(toServer: server)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.serverListController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServerItemTableViewCell", for: indexPath) as! ServerItemTableViewCell
        let server = vm.serverListController.object(at: indexPath)
        cell.update(withServerEntity: server, isConnected: isConnected(toServer: server))
        
        
//        cell.backgroundColor = server.address == vm.selectedServer?.address ? .red : .white
        if server.address == vm.selectedServer?.address {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
//            cell.setSelected(true, animated: false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let server = vm.serverListController.object(at: indexPath)
        vm.select(server: server)
    }
    
    
}
