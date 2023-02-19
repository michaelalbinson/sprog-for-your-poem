//
//  Decompressor.swift
//  Sprog For Your Poem
//
//  Created by Michael Albinson on 2/17/23.
//

import Foundation
import Gzip

class Decompressor {
    static func decompress(data: Data) -> Data? {
        if data.isGzipped {
            return try! data.gunzipped()
        } else {
            return nil
        }
    }
}
