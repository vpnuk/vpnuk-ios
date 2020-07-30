//
//  Appearence.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.07.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import UIKit
class Style {
    // MARK: - Spacing
    enum Spacing {
        static let noSpacing: CGFloat = 0
        static let smallSpacing: CGFloat = 4
        static let standartSpacing: CGFloat = 8
        static let bigSpacing: CGFloat = 16
    }
    
    // MARK: - Constreint
    enum Constraint {
        static let smallConstreint: CGFloat = 8
        static let standartConstreint: CGFloat = 16
        static let bigConstraint: CGFloat = 32
    }
    
    // MARK: - Color
    enum Color {
        static let blueColor = UIColor(red: 0.18, green: 0.439, blue: 0.627, alpha: 1).cgColor
        static let grayColor = UIColor(red: 0.569, green: 0.569, blue: 0.569, alpha: 1).cgColor
        static let grayTextColor = UIColor(red: 0.569, green: 0.569, blue: 0.569, alpha: 1)
        static let darkGrayColor = UIColor(red: 0.255, green: 0.325, blue: 0.365, alpha: 1)
        
    }
    // MARK: - Conrner Radius
    enum CornerRadius {
        static let smallCornerRadius: CGFloat = 5
        static let standartCornerRadius: CGFloat = 10
        static let bigCornerRadius: CGFloat = 20
    }
    
    // MARK: - Fonts
    enum Fonts {
        static let bigBoldFont = UIFont.boldSystemFont(ofSize: 20.0)
        static let bigFont = UIFont.systemFont(ofSize: 20.0)
        
        static let standartBoldFont = UIFont.boldSystemFont(ofSize: 16.0)
        static let standartFont = UIFont.systemFont(ofSize: 16.0)
        
        static let smallBoldFont = UIFont.boldSystemFont(ofSize: 14.0)
        static let smalldFont = UIFont.systemFont(ofSize: 14.0)
        
        static let minBoldFont = UIFont.boldSystemFont(ofSize: 12.0)
        static let minFont = UIFont.systemFont(ofSize: 12.0)
    }
    
}
