//
//  ServerItemTableViewCell.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 21.10.2019.
//  Copyright © 2019 VPNUK. All rights reserved.
//

import UIKit

class ServerItemTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dnsLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var serverTypeLabel: UILabel!
    @IBOutlet weak var isConnectedView: UIView!
    
    
    func update(withServerEntity server: ServerEntity, isConnected: Bool) {
        nameLabel.text = server.name
        iconLabel.text = server.icon
        cityLabel.text = server.city
        addressLabel.text = server.address
        dnsLabel.text = server.dns
        speedLabel.text = server.speed
        serverTypeLabel.text = server.type
        isConnectedView.isHidden = !isConnected
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
