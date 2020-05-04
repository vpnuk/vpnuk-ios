//
//  RestAPI.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 21.10.2019.
//  Copyright © 2019 VPNUK. All rights reserved.
//  Distributed under the GNU GPL v3 For full terms see the file LICENSE
//

import Foundation
import Alamofire
import XMLParsing


protocol AuthAPI {
    func signUp(withData data: SignUpRequestDTO, completion: @escaping (_ result: Result<Void, Error>) -> ())
    func signIn(withCredentials credentials: SignInCredentialsDTO, completion: @escaping (_ result: Result<SignInResponseDTO, Error>) -> ())
}

class RestAPI {
    static let shared = RestAPI()
    
    private let queue = DispatchQueue.global(qos: .userInitiated)
    func getServerList(callback: @escaping (_ servers: Result<[ServerDTO], Error>) -> ()) {
        AF.request(URL(string: "https://www.vpnuk.info/serverlist/servers.xml")!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseData(queue: queue) { (response) in
                if let error = response.error {
                    DispatchQueue.main.async {
                        callback(.failure(error))
                    }
                } else {
                    let data = response.data ?? Data()
                    do {
                        let decoder = XMLDecoder()
                        decoder.characterDataToken = "CharToken"
                        let servers = try decoder.decode(ParentServerDTO.self, from: data)
                        DispatchQueue.main.async {
                            callback(.success(servers.server ?? []))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            callback(.failure(error))
                        }
                    }
                }
        }
    }
    
    func getServersVersion(callback: @escaping (_ servers: Result<ServersVersionDTO, Error>) -> ()) {
        
        AF.request(
            URL(string: "https://www.vpnuk.info/serverlist/versions.xml")!,
            method: .get,
            parameters: nil,
            encoding: URLEncoding.default,
            headers: nil
        )
            .validate()
            .responseData(queue: queue) { (response) in
                if let error = response.error {
                    DispatchQueue.main.async {
                        callback(.failure(error))
                    }
                } else {
                    let data = response.data ?? Data()
                    do {
                        let servers = try XMLDecoder().decode(ServersVersionDTO.self, from: data)
                        DispatchQueue.main.async {
                            callback(.success(servers))
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

extension RestAPI: AuthAPI {
    func signUp(withData data: SignUpRequestDTO, completion: @escaping (Result<Void, Error>) -> ()) {
        AF.request(
            URL(string: "https://vpnuk.info/wp-json/vpnuk/v1/customers")!,
            method: .post,
            parameters: data,
            encoder: JSONParameterEncoder.default,
            headers: nil
            )
            .validate()
            .response(queue: queue) { (response) in
            DispatchQueue.main.async {
                if let error = response.error {
                    print(error)
                    completion(.failure(error as Error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
    
    func signIn(withCredentials credentials: SignInCredentialsDTO, completion: @escaping (Result<SignInResponseDTO, Error>) -> ()) {
         AF.request(
                   URL(string: "https://vpnuk.net/wp-json/vpnuk/v1/token")!,
                   method: .post,
                   parameters: credentials,
                   encoder: URLEncodedFormParameterEncoder.default,
                   headers: nil
               )
            .validate()
            .responseData(queue: DispatchQueue.global(qos: .userInitiated)) { (response) in
                       if let error = response.error {
                           DispatchQueue.main.async {
                               completion(.failure(error))
                           }
                       } else {
                           let data = response.data ?? Data()
                           do {
                               let servers = try JSONDecoder().decode(SignInResponseDTO.self, from: data)
                               DispatchQueue.main.async {
                                   completion(.success(servers))
                               }
                           } catch {
                               DispatchQueue.main.async {
                                   completion(.failure(error))
                               }
                           }
                       }
               }
    }
    
}
