//
//  ServerPickerView.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 10.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import UIKit
import SnapKit

class ServerPickerPickedView: UIView {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dnsLabel: UILabel!
    @IBOutlet weak var serverTypeLabel: UILabel!
    @IBOutlet weak var isConnectedView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    func update(withServerEntity server: ServerEntity, isConnected: Bool) {
        nameLabel.text = server.name
        if let iconName = server.icon?.lowercased() {
            iconImageView.image = UIImage(named: "\(iconName)1")
        } else {
            iconImageView.image = nil
        }
        cityLabel.text = server.city
        addressLabel.text = server.address
        dnsLabel.text = server.dns
        if let type = server.type {
            serverTypeLabel.text = ServerType(rawValue: type)?.shortTitle
        } else {
            serverTypeLabel.text = nil
        }
        isConnectedView.isHidden = !isConnected
    }
    
    private func commonInit() {
        fromNib()
        backgroundColor = .white
        contentView.makeDefaultShadowAndCorners()
        headerLabel.text = NSLocalizedString("Selected server:", comment: "")
    }
    
    required init?(coder aDecoder: NSCoder) {   // 2 - storyboard initializer
        super.init(coder: aDecoder)
        commonInit()
    }
    init() {   // 3 - programmatic initializer
        super.init(frame: CGRect.zero)  // 4.
        commonInit()
    }
    
}

