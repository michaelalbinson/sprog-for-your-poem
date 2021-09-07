//
//  RefreshOptions.swift
//  Sprog For Your Poem
//
//  Created by Michael Albinson on 2021-07-17.
//

import Foundation

enum RefreshOption: String {
    case
        DAILY,
        WEEKLY,
        BIWEEKLY,
        MONTHLY
    
    static func get(_ raw: String) -> RefreshOption {
        return RefreshOption(rawValue: raw) ?? RefreshOption.DAILY
    }
}
