//
//  ServerListViewController.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 26.10.2019.
//  Copyright © 2019 VPNUK. All rights reserved.
//  Distributed under the GNU GPL v3 For full terms see the file LICENSE
//

import UIKit

protocol ServerListDelegate: AnyObject {
    func serverPicked(atIndexPath indexPath: IndexPath, server: ServerEntity)
    func isConnected(toServer server: ServerEntity) -> Bool
    var selectedServer: ServerEntity? { get }
}
class ServerListViewController: UIViewController {
    @IBOutlet weak var serversTableView: UITableView!
    weak var delegate: ServerListDelegate?
    
    var serversType: ServerType?
    var servers: [ServerEntity] = [] {
        didSet {
            serversTableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        serversTableView.register(UINib(nibName: "ServerItemTableViewCell", bundle: nil), forCellReuseIdentifier: "ServerItemTableViewCell")
        
        serversTableView.delegate = self
        serversTableView.dataSource = self
        
        switch serversType {
        case .dedicated?:
            title = "Choose dedicated server"
        case .shared?:
            title = "Choose shared server"
        default:
            title = "Choose server"
        }
    }
    

}

extension ServerListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServerItemTableViewCell", for: indexPath) as! ServerItemTableViewCell
        let server = servers[indexPath.row]
        cell.update(withServerEntity: server, isConnected: delegate?.isConnected(toServer: server) ?? false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.serverPicked(atIndexPath: indexPath, server: servers[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
    
}
