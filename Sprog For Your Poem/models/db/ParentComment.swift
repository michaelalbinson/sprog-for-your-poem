//
//  ParentComment.swift
//  Sprog For Your Poem
//
//  Created by Michael Albinson on 2/12/23.
//

import Foundation
import SQLite

struct ParentComment: Codable, DatabaseModel {
    let user: String
    let gold: Int
    let silver: Int
    let platinum: Int
    let timestamp: Int64
    let link: String
    let content: String
    let id: Int64?
    let childPoemId: Int64
    let score: Int64
    let order: Int
    
    static func tableName() -> String {
        return "ParentComments"
    }
    
    static func fields() -> [String : ColumnType] {
        return [
            "user": ColumnType.T_String,
            "gold": ColumnType.T_Int,
            "silver": ColumnType.T_Int,
            "platinum": ColumnType.T_Int,
            "timestamp": ColumnType.T_Int64,
            "link": ColumnType.T_String,
            "content": ColumnType.T_String,
            "childPoemId": ColumnType.T_Int64,
            "order": ColumnType.T_Int,
            "score": ColumnType.T_Int64,
        ]
    }
    
    func save() -> ParentComment? {
        return ParentComment.dbSave(self) as ParentComment?
    }
    
    func delete() {
        if let _id = id {
            ParentComment.dbDelete(id: _id)
        }
    }
    
    static func getByPoemId(id: Int64) -> [ParentComment] {
        return dbQuery(Expression<Int64>("childPoemId") == id) as [ParentComment]
    }
    
    static func selectAll() -> [ParentComment] {
        return dbGetAll() as [ParentComment]
    }
}
