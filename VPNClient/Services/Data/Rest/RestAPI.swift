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

protocol AuthAPI {
    func signUp(withData data: SignUpRequestDTO, completion: @escaping (_ result: Result<Void, Error>) -> ())
    func signIn(withCredentials credentials: SignInCredentialsDTO, completion: @escaping (_ result: Result<SignInResponseDTO, Error>) -> ())
}

protocol ServersAPI {
    func getServerList(callback: @escaping (_ servers: Result<[ServerDTO], Error>) -> ())
}

protocol VersionsAPI {
    func getVersions(callback: @escaping (_ servers: Result<VersionsDTO, Error>) -> ())
}

protocol ServerFilesAPI {
    func downloadOVPNConfigurationFile(destinationUrl: URL, callback: @escaping (_ servers: Result<URL?, Error>) -> ())
    func downloadOVPNScrambledConfigurationFile(destinationUrl: URL, callback: @escaping (_ servers: Result<URL?, Error>) -> ())
}

protocol SubscripionsAPI {
    func getPurchasableProductIds(callback: @escaping (Result<[Int:Bool], Error>) -> ()) 
    func getSubscriptions(callback: @escaping (_ subscriptions: Result<[SubscriptionDTO], Error>) -> ())
    func getSubscription(withId id: String, callback: @escaping (_ subscription: Result<SubscriptionDTO, Error>) -> ())
    func createSubscription(subscriptionRequest: SubscriptionCreateRequestDTO, callback: @escaping (_ subscription: Result<SubscriptionCreateResponseDTO, Error>) -> ())
    func sendPurchaseReceipt(base64EncodedReceipt: String, country: String?, callback: @escaping (_ subscription: Result<Void, Error>) -> ())
    func renewOrder(orderId: String, base64EncodedReceipt: String, callback: @escaping (_ subscription: Result<Void, Error>) -> ())
}

class RestAPI {
    static let shared = RestAPI(
        authService: VPNUKAuthService(
            userCredentialsStorage: KeychainCredentialsStorage.buildForVPNUKAccount()
        )
    )
    
    private let serversBaseUrl = "https://www.serverlistvault.com"
    private let baseUrl = "https://www.vpnuk.info"
    private let queue = DispatchQueue.global(qos: .userInitiated)
    
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    private func getAuthHeaders() -> HTTPHeaders? {
        guard authService.isSignedIn, let token = try? authService.getAuthToken() else {
            return nil
        }
        return .init(["Authorization" : "Bearer \(token)"])
    }
}

extension RestAPI: ServerFilesAPI {
    func downloadOVPNConfigurationFile(destinationUrl destUrl: URL, callback: @escaping (Result<URL?, Error>) -> ()) {
        let destination: DownloadRequest.Destination = { _, _ in
            return (destUrl, [.removePreviousFile])
        }
        let url = serversBaseUrl + "/openvpn-configuration.ovpn"
        AF.download(url, to: destination).response { response in
            if let error = response.error {
                callback(.failure(error))
                return
            } else if let fileURL = response.fileURL {
                callback(.success(fileURL))
            } else {
                callback(.success(nil))
            }
        }
    }
    
    func downloadOVPNScrambledConfigurationFile(destinationUrl destUrl: URL, callback: @escaping (_ servers: Result<URL?, Error>) -> ()) {
        let destination: DownloadRequest.Destination = { _, _ in
            return (destUrl, [.removePreviousFile])
        }
        let url = serversBaseUrl + "/openvpn-obfuscation-configuration.ovpn"
        AF.download(url, to: destination).response { response in
            if let error = response.error {
                callback(.failure(error))
                return
            } else if let fileURL = response.fileURL {
                callback(.success(fileURL))
            } else {
                callback(.success(nil))
            }
        }
    }
}


extension RestAPI: ServersAPI {
    func getServerList(callback: @escaping (_ servers: Result<[ServerDTO], Error>) -> ()) {
        AF.request(URL(string: serversBaseUrl + "/servers.json")!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseData(queue: queue) { (response) in
                if let error = response.error {
                    DispatchQueue.main.async {
                        callback(.failure(error))
                    }
                } else {
                    let data = response.data ?? Data()
                    do {
                        let decoder = JSONDecoder()
                        let servers = try decoder.decode(ParentServerDTO.self, from: data)
                        DispatchQueue.main.async {
                            callback(.success(servers.servers ?? []))
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

extension RestAPI: VersionsAPI {
    func getVersions(callback: @escaping (_ servers: Result<VersionsDTO, Error>) -> ()) {
        AF.request(
            URL(string: serversBaseUrl + "/versions.json")!,
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
                        let servers = try JSONDecoder().decode(VersionsDTO.self, from: data)
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
            URL(string: baseUrl + "/wp-json/vpnuk/v1/customers")!,
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
            URL(string: baseUrl + "/wp-json/vpnuk/v1/token")!,
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


extension RestAPI: SubscripionsAPI {
    func getSubscriptions(callback: @escaping (Result<[SubscriptionDTO], Error>) -> ()) {
        AF.request(
            URL(string: baseUrl + "/wp-json/vpnuk/v1/subscriptions")!,
            method: .get,
            headers: getAuthHeaders()
        )
        .validate()
        .responseData(queue: DispatchQueue.global(qos: .userInitiated)) { (response) in
            if let error = response.error {
                DispatchQueue.main.async {
                    callback(.failure(error))
                }
            } else {
                let data = response.data ?? Data()
                do {
                    let servers = try JSONDecoder().decode([SubscriptionDTO].self, from: data)
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
    
    func getSubscription(withId id: String, callback: @escaping (Result<SubscriptionDTO, Error>) -> ()) {
        AF.request(
            URL(string: baseUrl + "/wp-json/vpnuk/v1/subscriptions/\(id)")!,
            method: .get,
            headers: getAuthHeaders()
        )
        .validate()
        .responseData(queue: DispatchQueue.global(qos: .userInitiated)) { (response) in
            if let error = response.error {
                DispatchQueue.main.async {
                    callback(.failure(error))
                }
            } else {
                let data = response.data ?? Data()
                do {
                    let servers = try JSONDecoder().decode(SubscriptionDTO.self, from: data)
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
    
    func createSubscription(subscriptionRequest: SubscriptionCreateRequestDTO, callback: @escaping (Result<SubscriptionCreateResponseDTO, Error>) -> ()) {
        AF.request(
            URL(string: baseUrl + "/wp-json/vpnuk/v1/subscriptions")!,
            method: .post,
            parameters: subscriptionRequest,
            headers: getAuthHeaders()
        )
        .validate()
        .responseData(queue: DispatchQueue.global(qos: .userInitiated)) { (response) in
            if let error = response.error {
                DispatchQueue.main.async {
                    callback(.failure(error))
                }
            } else {
                let data = response.data ?? Data()
                do {
                    let servers = try JSONDecoder().decode(SubscriptionCreateResponseDTO.self, from: data)
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
    
    func sendPurchaseReceipt(base64EncodedReceipt: String, country: String?, callback: @escaping (Result<Void, Error>) -> ()) {
        AF.request(
            URL(string: baseUrl + "/wp-json/vpnuk/v1/inapp/purchase")!,
            method: .post,
            parameters: IAPReceiptDTO(receipt: base64EncodedReceipt, country: country),
            encoder: JSONParameterEncoder.default,
            headers: getAuthHeaders()
        )
        .validate()
        .response(queue: DispatchQueue.global(qos: .userInitiated)) { (response) in
            if let error = response.error {
                DispatchQueue.main.async {
                    callback(.failure(error))
                }
            } else {
                DispatchQueue.main.async {
                    callback(.success(()))
                }
            }
        }
    }
    
    func getPurchasableProductIds(callback: @escaping (Result<[Int:Bool], Error>) -> ()) {
        AF.request(
            URL(string: baseUrl + "/wp-json/vpnuk/v1/purchasable_products")!,
            method: .get,
            headers: getAuthHeaders()
        )
        .validate()
        .responseData(queue: DispatchQueue.global(qos: .userInitiated)) { (response) in
            if let error = response.error {
                DispatchQueue.main.async {
                    callback(.failure(error))
                }
            } else {
                let data = response.data ?? Data()
                do {
                    let json = try JSONDecoder().decode([Int:Bool].self, from: data)
                    DispatchQueue.main.async {
                        callback(.success(json))
                    }
                } catch {
                    DispatchQueue.main.async {
                        callback(.failure(error))
                    }
                }
            }
        }
    }
    
    func renewOrder(
        orderId: String,
        base64EncodedReceipt: String,
        callback: @escaping (_ subscription: Result<Void, Error>) -> ()
    ) {
        AF.request(
            URL(string: baseUrl + "/wp-json/vpnuk/v1/inapp/purchase/order/\(orderId)")!,
            method: .post,
            parameters: IAPReceiptWithoutCountryDTO(receipt: base64EncodedReceipt),
            encoder: JSONParameterEncoder.default,
            headers: getAuthHeaders()
        )
        .validate()
        .responseData(queue: DispatchQueue.global(qos: .userInitiated)) { (response) in
            if let error = response.error {
                DispatchQueue.main.async {
                    callback(.failure(error))
                }
            } else {
                DispatchQueue.main.async {
                    callback(.success(()))
                }
            }
        }
    }
}
