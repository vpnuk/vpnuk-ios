//
//  AlertUtils.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 13.12.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation
import UIKit

class AlertUtils {
    private init() {}
    
    static func buildOkAlert(with message: String, completion: @escaping () -> ()) -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"), style: .default, handler: { _ in completion() })
        alertController.addAction(okAction)
        return alertController
    }
    
    static func buildOkCancelAlert(with message: String, okAction: @escaping () -> ()) -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"), style: .default, handler: { _ in okAction() })
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: { _ in })
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        return alertController
    }
}
