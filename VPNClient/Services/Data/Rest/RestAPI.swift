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
                            ServerDTO(location: ServerLocation(name: "ES 2", icon: "ES", city: "Madrid"), type: .shared, address: "37.235.53.23", dns: "shared2-es.vpnuk.net", speed: "1GBPS"),
                            ServerDTO(location: ServerLocation(name: "CH 1", icon: "CH", city: "Zurich"), type: .shared, address: "80.74.131.84", dns: "shared1-ch.vpnuk.net", speed: "100MBPS"),
                           
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
