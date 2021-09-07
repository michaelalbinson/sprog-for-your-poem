//
//  ATable.swift
//  Sprog For Your Poem
//
//  Created by Michael Albinson on 2021-07-16.
//

import Foundation
import SQLite

class SQLiteTable {
    static func getInsertErrorMessage(_ tableName: String) -> String {
        return "Error inserting row into table \(tableName)"
    }
    
    static func getTableCreateErrorMessage(_ tableName: String) -> String {
        return "Error creating table \(tableName)"
    }
    
    static func insertIfNoRowsPresent(table: Table, insertStmt: SQLite.Insert) {
        DBUtil.doWithDB { db in
            // check that an row doesn't exist in this table before writing in
            // a new one
            let metaRows = Array(try db.prepare(table))
            if 0 == metaRows.count {
                try db.run(insertStmt)
            }
        }
    }
}
