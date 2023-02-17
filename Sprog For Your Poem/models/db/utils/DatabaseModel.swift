//
//  DatabaseModel.swift
//  Sprog For Your Poem
//
//  Created by Michael Albinson on 2/12/23.
//

import Foundation
import SQLite

protocol DatabaseModel {    
    static func tableName() -> String
    
    static func fields() -> [String: ColumnType]
}

extension DatabaseModel {
    static func dbDelete(id: Int64) {
        do {
            try rawConnection().run(getTable().where(idColumn() == id).delete())
        } catch {
            print("Failed to delete row on table \(tableName()) with id \(id): \(error)")
        }
    }
    
    static func dbQuery<RowType: Codable>(_ expression: Expression<Bool>) -> [RowType] {
        return _getMany(expression) as [RowType]
    }
    
    static func dbGet<RowType: Codable>(id: Int64) -> RowType? {
        return _get(idColumn() == id) as RowType?
    }
    
    static func dbGet<RowType: Codable>(hash: String) -> RowType? {
        return _get(hashColumn() == hash) as RowType?
    }
    
    static func dbGetAll<RowType: Codable>() -> [RowType] {
        do {
            return try rawConnection().prepare(getTable()).map({ row in
                return try row.decode()
            }) as [RowType]
        } catch {
            print(error)
            return []
        }
    }
    
    private static func _get<RowType: Codable>(_ expression: Expression<Bool>) -> RowType? {
        do {
            let retrieved = try rawConnection().prepare(getTable().where(expression)).map({ row in
                return try row.decode()
            }) as [RowType]

            if retrieved.count == 0 {
                return nil
            }
            return retrieved[0]
        } catch {
            print(error)
            return nil
        }
    }
    
    private static func _getMany<RowType: Codable>(_ expression: Expression<Bool>) -> [RowType] {
        do {
            let retrieved = try rawConnection().prepare(getTable().where(expression)).map({ row in
                return try row.decode()
            }) as [RowType]

            if retrieved.count == 0 {
                return []
            }
            return retrieved
        } catch {
            print(error)
            return []
        }
    }
    
    static func dbSave<RowType: Codable>(_ toSave: RowType) -> RowType? {
        let rowId: Int64
        do {
            rowId = try rawConnection().run(getTable().upsert(toSave, onConflictOf: idColumn()))
        } catch {
            print(error)
            return nil
        }
        
        // refresh the in-memory row
        return dbGet(id: rowId) as RowType?
    }
    
    static func db() -> DatabaseManager {
        DatabaseManager.get()
    }
    
    static func rawConnection() -> Connection {
        DatabaseManager.get().rawConnection()
    }
    
    static func getTable() -> Table {
        if let cachedTable = DatabaseManager.getTable(tableName: tableName()) {
            return cachedTable
        } else {
            return createTable()
        }
    }
    
    private static func createTable() -> Table {
        if let cachedTable = DatabaseManager.getTable(tableName: tableName()) {
            return cachedTable
        }
        
        let table = Table(tableName())
        let fields = fields()
        do {
            try db().rawConnection().run(table.create(ifNotExists: false) { t in
                t.column(idColumn(), primaryKey: .autoincrement)

                for (fieldName, fieldType) in fields {
                    switch (fieldType) {
                    case .T_Int:
                        t.column(Expression<Int>(fieldName))
                        break;
                    case .T_Int64:
                        t.column(Expression<Int64>(fieldName))
                        break;
                    case .T_String:
                        t.column(Expression<String>(fieldName))
                        break;
                    case .T_Unique_String:
                        t.column(Expression<String>(fieldName), unique: true)
                        break
                    }
                }
            })
        } catch {
            print("Error creating table \(tableName()): \(error)")
        }
        
        print("Successfully created table \(tableName())")
        DatabaseManager.registerTable(tableName: tableName(), table: table)
        return table
    }
    
    static func idColumn() -> Expression<Int64> {
        return Expression<Int64>("id")
    }
    
    static func hashColumn() -> Expression<String> {
        return Expression<String>("hash")
    }
}
