//
//  DBManager.swift
//  Sprog For Your Poem
//
//  Created by Michael Albinson on 2/12/23.
//

import Foundation
import SQLite

class DatabaseManager {
    private var connection: Connection
    private static var MANAGER: DatabaseManager = DatabaseManager()
    private static let DB_NAME = "sprog.sqlite"
    private static var openStatements: [Statement] = []
    private static var allTables: [String: Table] = [:]
    
    // access to singleton
    static func get() -> DatabaseManager {
        return MANAGER
    }
    
    func rawConnection() -> Connection {
        return connection
    }
    
    static func registerTable(tableName: String, table: Table) {
        allTables[tableName] = table
    }
    
    static func getTable(tableName: String) -> Table? {
        return allTables[tableName]
    }
    
    static func registeredTables() -> [String: Table] {
        return allTables
    }
    
    static func testSeam_useMemoryDB() {
        MANAGER = DatabaseManager(testSeam: true)
    }
    
    static func setTrace(_ trace: Bool) {
        if trace {
            get().rawConnection().trace { print($0) }
        } else {
            get().rawConnection().trace(nil)
        }
    }
    
    static func testSeam_dropAllTables() {
        do {
            for (tableName, table) in DatabaseManager.registeredTables() {
                print("Deleting table \(tableName)")
                try get().rawConnection().run(table.drop(ifExists: true))
            }
        } catch {
            print(error)
        }
        
        allTables = [:]
    }
    
    // MARK: private

    private init(testSeam: Bool = false) {
        if (testSeam) {
            print("Connecting in memory for test seam")
            self.connection = DatabaseManager.connectInMemory()
            self.connection.trace { print($0) }
            return
        }
        
        self.connection = DatabaseManager.connect()
    }
    
    private static func connect() -> Connection {
        let fileURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent(DatabaseManager.DB_NAME)

        // open database
        var connection: Connection?
        do {
            connection = try Connection(fileURL.absoluteString)
        } catch {
            print("Failed to connect to DB with error: \(error)")
        }
        
        return connection!
    }
    
    private static func connectInMemory() -> Connection {
        var connection: Connection?
        do {
            connection = try Connection(.inMemory)
        } catch {
            print("Failed to connect to DB with error: \(error)")
        }
        
        return connection!
    }
}
