//
//  RestAPI.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 21.10.2019.
//  Copyright © 2019 VPNUK. All rights reserved.
//

import Foundation
import Alamofire
import XMLParsing

class RestAPI {
    static let shared = RestAPI()
    
    func getServerList(callback: @escaping (_ servers: Result<[ServerDTO]>) -> ()) {
        request(URL(string: "https://www.vpnuk.info/serverlist/servers.xml")!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseData(queue: DispatchQueue.global(qos: .userInitiated)) { (response) in
                if let error = response.error {
                    DispatchQueue.main.async {
                        callback(.failure(error))
                    }
                } else {
                    let data = response.data!
                    do {
                        
                        let servers = try XMLDecoder().decode([ServerDTO].self, from: data)
                        var mock: [ServerDTO] = [
                            ServerDTO(location: ServerLocation(name: "UK 61", icon: "UK", city: "Maidenhead"), type: .shared, address: "78.129.194.131", dns: "shared61.vpnuk.net", speed: "1GBPS"),
                           
                        ]
                        DispatchQueue.main.async {
                            callback(.success(mock))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            callback(.failure(error))
                        }
                    }
                }
        }
    }
}
