//
//  CustomConnectionDataViewModel.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 06.05.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation

protocol CustomConnectViewModelProtocol: VPNCredentialsProvider {
    var credentialsIsStoring: Bool { get }
    func storeCredentials(_ store: Bool)
}

class CustomConnectViewModel: CustomConnectViewModelProtocol {
    weak var view: CustomConnectViewProtocol? {
        didSet {
            viewLoaded()
        }
    }
    private let router: MainScreenRouterProtocol
    
    private let credentialsStorage: CredentialsStorage
    
    var credentialsChangedListener: ((UsernamePasswordCredentials) -> ())?
    
    var credentialsIsStoring: Bool {
        return (try? credentialsStorage.getCredentials()) != nil
    }
    
    init(router: MainScreenRouterProtocol, customCredentialsStorage: CredentialsStorage) {
        self.credentialsStorage = customCredentialsStorage
        self.router = router
    }
    
    func storeCredentials(_ store: Bool) {
        let credentials: UsernamePasswordCredentials?
        if store, let password = view?.password, let username = view?.username {
            credentials = UsernamePasswordCredentials(username: username, password: password)
        } else {
            credentials = nil
        }
        do {
            try credentialsStorage.setCredentials(credentials)
        } catch {
            //TODO: print cannot save
        }
        view?.updateCredentials()
    }
    
    func getCredentials() throws -> UsernamePasswordCredentials? {
        return try credentialsStorage.getCredentials()
    }
    
    private func viewLoaded() {
        view?.updateServerPicker(
            state: .notPicked,
            action: { [weak self] in
                guard let self = self else { return }
                self.router.presentServersPicker(delegate: self)
            }
        )
    }
}

extension CustomConnectViewModel: ServerPickerListViewModelProtocol {
    var selectedType: ServerType {
        .dedicated
    }
    
    var servers: [ServerType : [ServerEntity]] {
        [ServerType.dedicated:[]]
    }
    
    func isConnected(toServer server: ServerEntity) -> Bool {
        false
    }
    
    func select(server: ServerEntity) {
        
    }
    
    
}
