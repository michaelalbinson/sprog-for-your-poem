//
//  Poem.swift
//  Sprog For Your Poem
//
//  Created by Michael Albinson on 2021-07-15.
//

import Foundation
import SQLite

class Poem: SQLiteTable {
    static let TABLE_NAME: String = "poem"
    static let poemsTable = Table(TABLE_NAME)
    
    static let id = Expression<Int64>("id")
    static let gold = Expression<Int64>("gold")
    static let silver = Expression<Int64>("silver")
    static let platinum = Expression<Int64>("platinum")
    static let score = Expression<Int64>("score")
    static let timestamp = Expression<Int64>("timestamp")
    
    static let favorite = Expression<Bool>("favorite")

    static let link = Expression<String>("link")
    static let content = Expression<String>("orig_content") // the actual content of the comment
    static let submission_title = Expression<String>("submission_title")
    static let submission_user = Expression<String>("submission_user")
    static let author = Expression<String>("author")
    
    // reference fields - parent comment
    static let parent = Expression<Int64>("parent")
    
    init(from: [String: Any]) {
        
    }
    
    init(id: Int64) {
        
    }
    
    static func insert(
        gold: Int64, silver: Int64, platinum: Int64, score: Int64, timestamp: Int64,
        link: String, content: String, submission_title: String, submission_user: String, author: String,
        parent: Int64) {
        let insert = Poem.poemsTable.insert(
            Poem.gold <- gold,
            Poem.silver <- silver,
            Poem.platinum <- platinum,
            Poem.score <- score,
            Poem.timestamp <- timestamp,
            
            Poem.link <- link,
            Poem.content <- content,
            Poem.submission_title <- submission_title,
            Poem.submission_user <- submission_user,
            Poem.author <- author,
            
            Poem.parent <- parent
        )
        
        DBUtil.doWithDB(getInsertErrorMessage(TABLE_NAME)) { db in
            try db.run(insert)
        }
    }
    
    static func createTable() {
        let createTable = Poem.poemsTable.create(ifNotExists: true) { t in
            t.column(Poem.id, primaryKey: .autoincrement)
            t.column(Poem.gold)
            t.column(Poem.silver)
            t.column(Poem.platinum)
            t.column(Poem.score)
            t.column(Poem.timestamp)
            
            t.column(Poem.favorite)
            
            t.column(Poem.link)
            t.column(Poem.submission_title)
            t.column(Poem.submission_user)
            t.column(Poem.content)
            t.column(Poem.author)
            
            t.column(Poem.parent, references: PoemParent.poemParentTable, PoemParent.id)
        }
        
        DBUtil.doWithDB(getTableCreateErrorMessage(TABLE_NAME)) { db in
            try db.run(createTable)
        }
    }
    
    static func getTableName() -> String {
        return TABLE_NAME
    }
}
