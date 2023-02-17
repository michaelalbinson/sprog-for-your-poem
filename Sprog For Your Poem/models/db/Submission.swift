//
//  Submission.swift
//  Sprog For Your Poem
//
//  Created by Michael Albinson on 2/12/23.
//

import Foundation
import SQLite

struct Submission: Codable, DatabaseModel {
    let title: String
    let link: String
    let user: String
    let content: String
    let poemId: Int64
    let id: Int64?
    
    static func tableName() -> String {
        "Submissions"
    }
    
    static func fields() -> [String : ColumnType] {
        return [
            "user": ColumnType.T_String,
            "title": ColumnType.T_String,
            "link": ColumnType.T_String,
            "content": ColumnType.T_String,
            "poemId": ColumnType.T_Int64,
        ]
    }
    
    func save() -> Submission? {
        return Submission.dbSave(self) as Submission?
    }
    
    func delete() {
        if let _id = id {
            Submission.dbDelete(id: _id)
        }
    }
    
    static func getByPoemId(id: Int64) -> Submission? {
        let result = dbQuery(Expression<Int64>("poemId") == id) as [Submission]
        if result.count > 0 {
            return result[0]
        }
        
        return nil
    }
    
    static func selectAll() -> [Submission] {
        return dbGetAll() as [Submission]
    }
}
