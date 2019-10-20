//
//  SettingsViewController.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.10.2019.
//  Copyright © 2019 VPNUK. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var protocolSegmentedControl: UISegmentedControl!
    @IBOutlet weak var portSegmentedControl: UISegmentedControl!
    @IBOutlet weak var reconnectSwitcher: UISwitch!
    
    @IBAction func protocolChanged(_ sender: UISegmentedControl) {
    }
    
    @IBAction func portChanged(_ sender: UISegmentedControl) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
