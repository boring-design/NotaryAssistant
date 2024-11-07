//
//  CredentialService.swift
//  NotaryAssistant
//
//  Created by STRRL on 2024-11-05.
//

import Foundation
import Security

final class CredentialService {
    public static var shared: CredentialService = .init()

    private let service = "NotaryAssistant"
    private let appleIDKey = "appleID"
    private let passwordKey = "password"
    private let teamIDKey = "teamID"

    public func saveCredentials(appleID: String, password: String, teamID: String) {
        saveToKeychain(key: appleIDKey, value: appleID)
        saveToKeychain(key: passwordKey, value: password)
        saveToKeychain(key: teamIDKey, value: teamID)
    }

    public func loadCredentials() -> (appleID: String, password: String, teamID: String) {
        let appleID = loadFromKeychain(key: appleIDKey) ?? ""
        let password = loadFromKeychain(key: passwordKey) ?? ""
        let teamID = loadFromKeychain(key: teamIDKey) ?? ""
        return (appleID, password, teamID)
    }

    private func saveToKeychain(key: String, value: String) {
        let data = value.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
        ]

        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            print("Error saving to Keychain: \(status)")
            return
        }
    }

    private func loadFromKeychain(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else {
            return nil
        }

        guard let data = item as? Data else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }
}
