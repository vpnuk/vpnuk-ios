//
//  OpenVPNConfigurationRepository.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 24.10.2021.
//  Copyright © 2021 VPNUK. All rights reserved.
//

import Foundation

protocol OpenVPNConfigurationRepositoryProtocol {
    var fileUrl: URL { get }
    var isFileExist: Bool { get }
    func downloadOVPNConfigurationFile(completion: @escaping (_ result: Result<URL, Error>) -> ())
}

class OpenVPNConfigurationRepository {
    lazy var fileUrl: URL = {
        var documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        documentsURL.appendPathComponent("vpnuk-openvpn-configuration.ovpn")
        return documentsURL
    }()
    private let fileManager = FileManager.default
    private let api: ServerFilesAPI
    
    init(api: ServerFilesAPI) {
        self.api = api
    }
}

extension OpenVPNConfigurationRepository: OpenVPNConfigurationRepositoryProtocol {
    var isFileExist: Bool {
        return fileManager.fileExists(atPath: fileUrl.path)
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
}
