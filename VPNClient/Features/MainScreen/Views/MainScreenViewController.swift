//
//  MainScreenViewController.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 08.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import UIKit
import SnapKit

protocol MainScreenViewProtocol: AlertPresentable, LoaderPresentable {
    func replaceConnectView(with view: UIView)
    func updateConnectScreenSwitcher(model: MainScreenViewController.ConnectScreenSwitcherModel)
    var connectionStatusView: ConnectionStatusViewProtocol { get }
}

class MainScreenViewController: UIViewController {
    
    private let viewModel: MainScreenViewModelProtocol
    private var connectScreenSelectedAction: ((Int) -> Void)?
    
    // header
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "gear"), for: .normal)
        button.addTarget(self, action: #selector(settingsTouched), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var supportButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "live_support"), for: .normal)
        button.addTarget(self, action: #selector(supportTouched), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(supportButton)
        stack.addArrangedSubview(settingsButton)
        stack.axis = .horizontal
        stack.spacing = 20
        return stack
    }()
    
    private lazy var headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
    private lazy var connectScreenSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.addTarget(self, action: #selector(connectScreenSegmentedControlSelected(sender:)), for: .valueChanged)
        return control
    }()
    
    private lazy var connectScreenSegmentedControlLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Login with:", comment: "")
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private lazy var imageContainerView: UIView = {
        let view = UIView()
        view.addSubview(headerImageView)
        return view
    }()
    
    private lazy var headerStackView: UIStackView = {
        let leftV = UIView()
        let rigthV = UIView()
        let connectScreenStackView = UIStackView(
            arrangedSubviews: [
                leftV,
                connectScreenSegmentedControlLabel,
                connectScreenSegmentedControl,
                rigthV
            ]
        )
        leftV.snp.makeConstraints { (make) in
            make.width.equalTo(rigthV.snp.width)
        }
        connectScreenStackView.axis = .horizontal
        connectScreenStackView.spacing = 16
        
        
        let headerStackView = UIStackView(
            arrangedSubviews: [
                imageContainerView,
                connectScreenStackView
            ]
        )
        headerStackView.axis = .vertical
        headerStackView.spacing = 16
        return headerStackView
    }()
    
    // Connect View
    
    private lazy var connectView: UIView = {
        let view = UIView()
        return view
    }()
    
    // bottom connection status
    
    var statusView: ConnectionStatusView = {
        return ConnectionStatusView()
    }()
    
    // content view
    
    private lazy var contentStackView: UIStackView = {
        let spacerView = UIView()
        spacerView.backgroundColor = .clear
        let stackView = UIStackView(
            arrangedSubviews: [
                headerStackView.contained(with: .init(top: 16, left: 0, bottom: 16, right: 0)),
                connectView,
                spacerView,
                statusView
            ]
        )
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
   
    init(viewModel: MainScreenViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        view.addSubview(contentStackView)
        view.addSubview(buttonsStackView)
        
    }
    
    private func setupConstraints() {
        contentStackView.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailingMargin)
        }
        
        headerImageView.snp.makeConstraints { (make) in
            make.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.center.equalToSuperview()
        }
        
        statusView.snp.makeConstraints { (make) in
            make.height.equalTo(100)
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.top.right.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(25)
        }
        
        settingsButton.snp.makeConstraints { make in
            make.size.equalTo(25)
        }
        
        supportButton.snp.makeConstraints { make in
            make.size.equalTo(25)
        }
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
        viewModel.viewLoaded()
    }
    
    @objc
    private func connectScreenSegmentedControlSelected(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        connectScreenSelectedAction?(index)
    }
    
    @objc
    private func settingsTouched() {
        viewModel.openSettingsTouched()
    }
    
    @objc
    private func supportTouched() {
        viewModel.openSupportTouched()
    }

}

extension MainScreenViewController: MainScreenViewProtocol {
    var connectionStatusView: ConnectionStatusViewProtocol {
        statusView
    }
    
    func updateConnectScreenSwitcher(model: MainScreenViewController.ConnectScreenSwitcherModel) {
        connectScreenSegmentedControl.removeAllSegments()
        for item in model.items.reversed() {
            connectScreenSegmentedControl.insertSegment(
                withTitle: item,
                at: 0,
                animated: false
            )
        }
        connectScreenSelectedAction = model.itemSelectedAction
        if let index = model.selectedIndex {
            connectScreenSegmentedControl.selectedSegmentIndex = index
        } else {
            connectScreenSegmentedControl.selectedSegmentIndex = -1
        }
    }
    
    func replaceConnectView(with view: UIView) {
        connectView.removeSubviews()
        connectView.addSubview(view)
        view.makeEdgesEqualToSuperview()
    }
}

extension MainScreenViewController {
    struct ConnectScreenSwitcherModel {
        let items: [String]
        let selectedIndex: Int?
        let itemSelectedAction: (Int) -> Void
    }
}
