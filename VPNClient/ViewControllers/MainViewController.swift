//
//  MainViewController.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.10.2019.
//  Copyright © 2019 VPNUK. All rights reserved.
//  Distributed under the GNU GPL v3 For full terms see the file LICENSE
//

import UIKit
import NetworkExtension

class MainViewController: UIViewController {

    @IBOutlet weak var refreshServersIndicator: UIActivityIndicatorView!
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
    let vm: MainViewModel = MainViewModel()
    
    @IBAction func savePasswordTouched(_ sender: UIButton) {
        savePasswordButton.isSelected = !savePasswordButton.isSelected
        vm.storeCredentials = savePasswordButton.isSelected
        updateSavePasswordSelector()
    }
    
    @IBAction func refreshServersTouched(_ sender: UIButton) {
        vm.updateServersIfNeeded(forceReload: true)
    }
    
    @IBAction func serverTypeChanged(_ sender: UISegmentedControl) {
        let newType: ServerType = sender.selectedSegmentIndex == 0 ? .shared : .dedicated
        if newType != vm.serversType {
             vm.serversType = newType
        }
    }
    
    @IBAction func connectTouched(_ sender: UIButton) {
        vm.connectTouched()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        vm.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func setupViews() {
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        serversListTableView.register(UINib(nibName: "ServerItemTableViewCell", bundle: nil), forCellReuseIdentifier: "ServerItemTableViewCell")
        vm.view = self
        updateServerTypeSwitcher()
        serversListTableView.delegate = self
        serversListTableView.dataSource = self
        connectionStatusLabel.text = "Disconnected"
        connectionStatusLabel.textColor = .red
        updateSavePasswordSelector()
        
    }
    
    private func updateServerTypeSwitcher() {
        serversTypeSegmentedControl.selectedSegmentIndex = vm.serversType == .shared ? 0 : 1
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
    func serversLoadingIndicator(show: Bool) {
        if show {
            refreshServersIndicator.startAnimating()
        } else {
            refreshServersIndicator.stopAnimating()
        }
    }
    
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
                connectionStatusLabel.text = "Connecting to \(ip):\(port), \(proto.rawValue)..."
            } else {
                connectionStatusLabel.text = "Connecting..."
            }
            connectionStatusLabel.textColor = .orange
        case .connected:
            connectButton.setTitle("Disconnect", for: .normal)
            if let ip = vm.serverIP, let port = vm.port, let proto = vm.socketType {
                connectionStatusLabel.text = "Connected to \(ip):\(port), \(proto.rawValue)"
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
        self.updateServerTypeSwitcher()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            let count = self.tableView(self.serversListTableView, numberOfRowsInSection: 0)
            if indexPath.row < count {
                self.serversListTableView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
        if server.address == vm.selectedServer?.address {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let server = vm.serverListController.object(at: indexPath)
        vm.select(server: server)
    }
    
    
}
