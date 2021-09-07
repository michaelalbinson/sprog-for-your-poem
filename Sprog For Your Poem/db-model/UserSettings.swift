//
//  UserSettings.swift
//  Sprog For Your Poem
//
//  Created by Michael Albinson on 2021-07-17.
//

import Foundation
import SQLite

// singleton class for managing user preferences for the application
class UserSettings: SQLiteTable {
    static let TABLE_NAME: String = "user_settings"
    static let userSettingsTable = Table(TABLE_NAME)
    
    static let id = Expression<Int64>("id")
    static let refresh_cadence = Expression<String>("refresh_cadence")
    static let retention_policy = Expression<String>("retention_policy")
    
    static let META_ROW_ID: Int64 = 1
    static var refreshCadence: RefreshOption = .DAILY
    static var retention: RetentionOption = .ALL
    
    static func getRefreshCadence() -> RefreshOption {
        return refreshCadence
    }
    
    static func setRefreshCadence(_ new: RefreshOption) {
        refreshCadence = new
        runUpdate()
    }
    
    static func getRetention() -> RetentionOption {
        return retention
    }
    
    static func setRetention(_ new: RetentionOption) {
        retention = new
        runUpdate()
    }
    
    static func createTableAndLoad() {
        let createTableQuery = userSettingsTable.create(ifNotExists: true) { t in
            t.column(UserSettings.id, primaryKey: true)
            t.column(UserSettings.refresh_cadence)
            t.column(UserSettings.retention_policy)
        }
        
        // default retention
        let insertRow = userSettingsTable.insert(
            id <- META_ROW_ID,
            refresh_cadence <- RefreshOption.DAILY.rawValue,
            retention_policy <- RetentionOption.ALL.rawValue
        )
        
        DBUtil.doWithDB(getTableCreateErrorMessage(TABLE_NAME)) { db in
            // create the table if it doesn't already exist
            try db.run(createTableQuery)
        }
        
        // insert a new settings row if one doesn't already exist and then
        // load it into memory
        insertIfNoRowsPresent(table: userSettingsTable, insertStmt: insertRow)
        loadMetadata()
    }
    
    private static func loadMetadata() {
        DBUtil.doWithDB { db in
            if let settings = try db.pluck(userSettingsTable) {
                self.refreshCadence = RefreshOption.get(settings[refresh_cadence])
                self.retention = RetentionOption.get(settings[retention_policy])
            }
        }
    }
    
    private static func runUpdate() {
        DBUtil.doWithDB() { db in
            let metaRow = userSettingsTable.filter(UserSettings.id == META_ROW_ID)
            try db.run(
                metaRow.update(
                    refresh_cadence <- self.refreshCadence.rawValue,
                    retention_policy <- self.retention.rawValue
                )
            )
        }
    }
}
