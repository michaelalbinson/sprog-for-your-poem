//
//  AppMetadata.swift
//  Sprog For Your Poem
//
//  Created by Michael Albinson on 2021-07-16.
//

import Foundation
import SQLite

// singleton class for storing metadata about the application state
class AppMetadata: SQLiteTable {
    static let TABLE_NAME: String = "app_metadata"
    static let appMetadataTable = Table(TABLE_NAME)
    
    static let id = Expression<Int64>("id")
    static let poem_row_count = Expression<Int64>("poem_row_count")
    static let last_60_day_byte_length = Expression<Int64>("last_60_day_byte_length")
    
    static let META_ROW_ID: Int64 = 1
    
    static var rowCount: Int64 = 0
    static var lastByteLength: Int64 = 0
    
    static func getPoemRowCount() -> Int64 {
        return rowCount
    }
    
    static func setPoemRowCount(_ rowCount: Int64) {
        self.rowCount = rowCount
        runUpdate()
    }
    
    static func getLast60DayByteLength() -> Int64 {
        return lastByteLength
    }
    
    static func setLast60DayByteLength(_ lastByteLength: Int64) {
        self.lastByteLength = lastByteLength
        runUpdate()
    }
    
    static func loadMetadata() {
        DBUtil.doWithDB { db in
            if let meta = try db.pluck(appMetadataTable) {
                self.rowCount = meta[poem_row_count]
                self.lastByteLength = meta[last_60_day_byte_length]
            }
        }
    }
    
    private static func runUpdate() {
        DBUtil.doWithDB() { db in
            let metaRow = appMetadataTable.filter(AppMetadata.id == META_ROW_ID)
            try db.run(
                metaRow.update(
                    poem_row_count <- self.rowCount,
                    last_60_day_byte_length <- self.lastByteLength
                )
            )
        }
    }
    
    static func createTableAndLoad() {
        let createTable = appMetadataTable.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(poem_row_count)
            t.column(last_60_day_byte_length)
        }
        
        let insertRow = appMetadataTable.insert(
            id <- META_ROW_ID,
            poem_row_count <- 0,
            last_60_day_byte_length <- 0
        )
        
        DBUtil.doWithDB(getTableCreateErrorMessage(TABLE_NAME)) { db in
            // create the table if it doesn't already exist
            try db.run(createTable)
        }
        
        // insert a new metadata row if one doesn't already exist and then
        // load the metadata
        insertIfNoRowsPresent(table: appMetadataTable, insertStmt: insertRow)
        loadMetadata()
    }
}
