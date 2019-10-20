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
    
    @IBOutlet weak var serversListTableView: UITableView!
    @IBOutlet weak var connectionStatusLabel: UILabel!
    
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
        vm.view = self
        serversTypeSegmentedControl.selectedSegmentIndex = vm.serversType == .shared ? 0 : 1
        serversListTableView.delegate = self
        serversListTableView.dataSource = self
    }
}

extension MainViewController: MainView {
    func serverListUpdated() {
        serversListTableView.reloadData()
    }
    
    func statusUpdated(newStatus status: NEVPNStatus) {
        switch status {
        case .connected, .connecting:
            connectButton.setTitle("Disconnect", for: .normal)
            
        case .disconnected:
            connectButton.setTitle("Connect", for: .normal)
            
        case .disconnecting:
            connectButton.setTitle("Disconnecting", for: .normal)
        default:
            break
        }
    }
    
    var username: String? {
        return usernameTextField.text
    }
    
    var password: String? {
        return passwordTextField.text
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.serverListController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServerItemTableViewCell", for: indexPath) as! ServerItemTableViewCell
        let server = vm.serverListController.object(at: indexPath)
        cell.update(withServerEntity: server, isConnected: vm.isConnected(toServer: server))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let server = vm.serverListController.object(at: indexPath)
        vm.select(server: server)
    }
    
}
