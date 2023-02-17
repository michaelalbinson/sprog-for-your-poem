//
//  Sha256.swift
//  Sprog For Your Poem
//
//  Created by Michael Albinson on 2/17/23.
//

import Foundation
import CryptoKit

class Sha256 {
    static func sha256(text: String) -> String {
        let data = text.data(using: .utf8)!
        let hash = SHA256.hash(data: data)
        return Data(hash).base64EncodedString()
    }
}
