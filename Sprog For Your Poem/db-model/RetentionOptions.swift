//
//  RetentionOptions.swift
//  Sprog For Your Poem
//
//  Created by Michael Albinson on 2021-07-17.
//

import Foundation

enum RetentionOption: String {
    case
        ALL,
        DAYS_90,
        DAYS_60,
        DAYS_30
    
    static func get(_ raw: String) -> RetentionOption {
        return RetentionOption(rawValue: raw) ?? RetentionOption.ALL
    }
}
