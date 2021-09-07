//
//  PostParent.swift
//  Sprog For Your Poem
//
//  Created by Michael Albinson on 2021-07-16.
//

import Foundation
import SQLite

class PoemParent: SQLiteTable {
    static let TABLE_NAME: String = "poem_parent"
    static let poemParentTable = Table(TABLE_NAME)
    
    static let id = Expression<Int64>("id")
    static let gold = Expression<Int64>("gold")
    static let silver = Expression<Int64>("silver")
    static let platinum = Expression<Int64>("platinum")
    static let score = Expression<Int64>("score")
    static let timestamp = Expression<Int64>("timestamp")
    
    static let link = Expression<String?>("link")
    static let content = Expression<String?>("orig_body")
    static let author = Expression<String?>("author")
    
    init(from: JsonPoemParent) {
        PoemParent.insert(
            gold: from.gold, silver: from.silver, platinum: from.platinum,
            score: from.score, timestamp: from.timestamp, link: from.link,
            content: from.orig_body, author: from.author
        )
    }
    
    init(id: Int64) {
        
    }
    
    static func insert(
        gold: Int64, silver: Int64, platinum: Int64, score: Int64, timestamp: Int64,
        link: String, content: String, author: String) {
        let insert = poemParentTable.insert(
            PoemParent.gold <- gold,
            PoemParent.silver <- silver,
            PoemParent.platinum <- platinum,
            PoemParent.score <- score,
            PoemParent.timestamp <- timestamp,
            
            PoemParent.link <- link,
            PoemParent.content <- content,
            PoemParent.author <- author
        )
        
        DBUtil.doWithDB(getInsertErrorMessage(TABLE_NAME)) { db in
            try db.run(insert)
        }
    }
    
    static func createTable() {
        let createTableQuery = poemParentTable.create(ifNotExists: true) { t in
            t.column(PoemParent.id, primaryKey: .autoincrement)
            t.column(PoemParent.gold)
            t.column(PoemParent.silver)
            t.column(PoemParent.platinum)
            t.column(PoemParent.score)
            t.column(PoemParent.timestamp)
            
            t.column(PoemParent.link)
            t.column(PoemParent.content)
            t.column(PoemParent.author)
        }
        
        DBUtil.doWithDB(getTableCreateErrorMessage(TABLE_NAME)) { db in
            try db.run(createTableQuery)
        }
    }
    
    static func rowExists(link: String, handler: (Bool) -> Void) {
        let filteredTable = poemParentTable.filter(PostParent.link == link)
        DBUtil.doWithDB() { db in
            if let _ = try db.pluck(filteredTable) {
                handler(true)
                return
            }
            
            handler(false)
        }
    }
    
    static func getTableName() -> String {
        return TABLE_NAME
    }
}
