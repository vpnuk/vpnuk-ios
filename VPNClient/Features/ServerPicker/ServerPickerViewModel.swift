//
//  ServerPickerViewModel.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.06.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation

struct ServerTablePosition: Equatable {
    let type: ServerType
    let index: Int
}

protocol ServerPickerListViewModelProtocol: AnyObject {
    var servers: [ServerType : [ServerEntity]] { get }
    var view: ServerPickerListViewProtocol? { get set }
    func isConnected(toServerAt position: ServerTablePosition) -> Bool
    func select(serverAt position: ServerTablePosition)
    var selectedType: ServerType { get set }
}

class ServerPickerListViewModel {
    weak var view: ServerPickerListViewProtocol?
    private(set) var servers: [ServerType : [ServerEntity]]
    private var connectedServerPosition: ServerTablePosition?
    private var selectServerAtAction: (ServerTablePosition) -> ()
    private let initiallySelectedPosition: ServerTablePosition?
    var selectedType: ServerType {
        didSet {
            view?.update()
        }
    }
    
    init(
        initiallySelectedPosition: ServerTablePosition?,
        servers: [ServerType : [ServerEntity]],
        connectedServerPosition: ServerTablePosition?,
        selectServerAtAction: @escaping (ServerTablePosition) -> ()
    ) {
        self.servers = servers
        self.connectedServerPosition = connectedServerPosition
        self.selectServerAtAction = selectServerAtAction
        self.selectedType = initiallySelectedPosition?.type ?? .shared
        self.initiallySelectedPosition = initiallySelectedPosition
    }
}

extension ServerPickerListViewModel: ServerPickerListViewModelProtocol {
    func isConnected(toServerAt position: ServerTablePosition) -> Bool {
        guard let connectedServerPosition = connectedServerPosition else { return false }
        return connectedServerPosition == position
    }
    
    func select(serverAt position: ServerTablePosition) {
        selectServerAtAction(position)
        view?.dismissView()
    }
}
