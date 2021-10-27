//
//  OpenVPNConfigurationRepository.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 24.10.2021.
//  Copyright © 2021 VPNUK. All rights reserved.
//

import Foundation

protocol OpenVPNConfigurationRepositoryProtocol {
    var ovpnScrambledConfigurationFileInfo: OpenVPNConfigurationRepositoryLocalFileInfo { get }
    var ovpnConfigurationFileInfo: OpenVPNConfigurationRepositoryLocalFileInfo { get }
    func downloadOVPNConfigurationFile(completion: @escaping (_ result: Result<URL, Error>) -> ())
    func downloadOVPNScrambledConfigurationFile(completion: @escaping (_ result: Result<URL, Error>) -> ())
}

struct OpenVPNConfigurationRepositoryLocalFileInfo {
    let isFileExistAtURL: Bool
    let fileUrl: URL
}

class OpenVPNConfigurationRepository {
    private lazy var fileUrl: URL = {
        var documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        documentsURL.appendPathComponent("vpnuk-openvpn-configuration.ovpn")
        return documentsURL
    }()
    private lazy var scrambledFileUrl: URL = {
        var documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        documentsURL.appendPathComponent("vpnuk-openvpn-scrambled-configuration.ovpn")
        return documentsURL
    }()
    private let fileManager = FileManager.default
    private let api: ServerFilesAPI
    
    init(api: ServerFilesAPI) {
        self.api = api
    }
}

extension OpenVPNConfigurationRepository: OpenVPNConfigurationRepositoryProtocol {
    var ovpnScrambledConfigurationFileInfo: OpenVPNConfigurationRepositoryLocalFileInfo {
        .init(isFileExistAtURL: fileManager.fileExists(atPath: scrambledFileUrl.path), fileUrl: scrambledFileUrl)
    }
    
    var ovpnConfigurationFileInfo: OpenVPNConfigurationRepositoryLocalFileInfo {
        .init(isFileExistAtURL: fileManager.fileExists(atPath: fileUrl.path), fileUrl: fileUrl)
    }
    
    func downloadOVPNConfigurationFile(completion: @escaping (_ result: Result<URL, Error>) -> ()) {
        let fileUrl = fileUrl
        api.downloadOVPNConfigurationFile(destinationUrl: fileUrl) { result in
            switch result {
            case .success(let url):
                completion(.success(url ?? fileUrl))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func downloadOVPNScrambledConfigurationFile(completion: @escaping (Result<URL, Error>) -> ()) {
        let fileUrl = scrambledFileUrl
        api.downloadOVPNConfigurationFile(destinationUrl: fileUrl) { result in
            switch result {
            case .success(let url):
                completion(.success(url ?? fileUrl))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
