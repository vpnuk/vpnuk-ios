//
//  ServersDbRepository.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.06.2020.
//  Copyright © 2020 VPNUK. All rights reserved.
//

import Foundation

protocol ServersRepository {
    func getServers(forTypes types: [ServerType]) -> [ServerEntity]
    func getServer(byIp ip: String) -> ServerEntity?
    func updateServers(completion: @escaping (_ result: Result<Void, Error>) -> ())
}

class ServersRepositoryImpl {
    private let coreDataStack: CoreDataStack
    private let serversRestAPI: ServersAPI
    
    init(coreDataStack: CoreDataStack, serversRestAPI: ServersAPI) {
        self.coreDataStack = coreDataStack
        self.serversRestAPI = serversRestAPI
    }
}


extension ServersRepositoryImpl: ServersRepository {
    func getServers(forTypes types: [ServerType]) -> [ServerEntity] {
        ServerEntity.find(byTypes: types, in: coreDataStack.context)
    }
    
    func getServer(byIp ip: String) -> ServerEntity? {
        ServerEntity.find(byIP: ip, in: coreDataStack.context)
    }
    
    func updateServers(completion: @escaping (Result<Void, Error>) -> ()) {
        let context = coreDataStack.context
        serversRestAPI.getServerList { result in
            switch result {
            case .success(let servers):
                ServerEntity.update(withDtos: servers, in: context) {
                    completion(.success(()))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
