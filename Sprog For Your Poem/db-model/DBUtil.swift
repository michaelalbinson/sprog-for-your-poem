//
//  DBHelper.swift
//  Sprog For Your Poem
//
//  Created by Michael Albinson on 2021-07-15.
//

import Foundation
import SQLite

class DBUtil {
    static var dbConnnection: Connection?
    
    static func getDB() -> Connection? {
        // short-circuit if we already have a cached connection to the db
        if dbConnnection != nil {
            return dbConnnection
        }

        // get the path to the sqlite database
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!

        // actually connect to the database
        do {
            dbConnnection = try Connection("\(path)/db.sqlite3")
            return dbConnnection
        } catch let error {
            LogUtil.logError("Failed to open a connection to the database, all subsequent calls with fail! Error: \(error)")
            return nil
        }
    }
    
    /**
     * Utility method for executing a series of actions with a centrally managed DB connection
     * - Parameters:
     *   - errorMessage: optional message to log if an error occurs
     *   - callback: callable for executing an arbitrary database task
     */
    static func doWithDB(_ errorMessage: String?, callback: (Connection) throws -> Void) {
        if let db = getDB() {
            do {
                try callback(db)
            } catch let error {
                if nil != errorMessage {
                    LogUtil.logError(errorMessage!)
                } else {
                    LogUtil.logError("Caught error while executing DB task \(error)")
                }
            }
        }
    }
    
    static func doWithDB(_ callback: (Connection) throws -> Void) {
        doWithDB(nil, callback: callback)
    }
    
    /// Generate all database tables if they don't exist, and load in AppMetadata and
    /// UserSettings
    static func runSetup() {
        AppMetadata.createTableAndLoad()
        UserSettings.createTableAndLoad()
        PoemParent.createTable()
        Poem.createTable()
    }
}
