//
//  Poem.swift
//  Sprog For Your Poem
//
//  Created by Michael Albinson on 2/12/23.
//

import Foundation
import SQLite

struct Poem: Codable, DatabaseModel {
    let gold: Int
    let platinum: Int
    let score: Int64
    let link: String
    let content: String
    let silver: Int
    let timestamp: Int64
    let user: String
    let id: Int64?
    let hash: String
    
    init(gold: Int, platinum: Int, score: Int64, link: String, content: String, silver: Int, timestamp: Int64, user: String, id: Int64? = nil) {
        self.gold = gold
        self.platinum = platinum
        self.score = score
        self.link = link
        self.content = content
        self.silver = silver
        self.timestamp = timestamp
        self.user = user
        self.hash = Poem.hash(link: link, timestamp: timestamp)
        self.id = id
    }
    
    static func from_json(json: [String: Any]) -> Poem {
        return Poem(
            gold: json["gold"] as? Int ?? 0,
            platinum: json["platinum"] as? Int ?? 0,
            score: json["score"] as? Int64 ?? 0,
            link: json["link"] as? String ?? "",
            content: json["orig_body"] as? String ?? "",
            silver: json["silver"] as? Int ?? 0,
            timestamp: json["timestamp"] as? Int64 ?? 0,
            user: "Poem_for_your_sprog"
        )
    }
    
    static func load_from_json(json: [String: Any]) -> Poem {
        return from_json(json: json)
    }
    
    static func tableName() -> String {
        return "Poem"
    }
    
    static func fields() -> [String: ColumnType] {
        return [
            "gold": ColumnType.T_Int,
            "platinum": ColumnType.T_Int,
            "silver": ColumnType.T_Int,
            "score": ColumnType.T_Int64,
            "timestamp": ColumnType.T_Int64,
            "content": ColumnType.T_String,
            "user": ColumnType.T_String,
            "link": ColumnType.T_String,
            "hash": ColumnType.T_Unique_String
        ]
    }
    
    static func hash(link: String, timestamp: Int64) -> String {
        return Sha256.sha256(text: "\(link)_\(timestamp)")
    }
    
    static func selectAll() -> [Poem] {
        return dbGetAll() as [Poem]
    }
    
    static func get(id: Int64) -> Poem? {
        return dbGet(id: id)
    }
    
    static func get(hash: String) -> Poem? {
        return dbGet(hash: hash)
    }
    
    static func poemLoaded(poemJson: SprogJson) -> Bool {
        if let _ = Poem.get(hash: Poem.hash(link: poemJson.link, timestamp: poemJson.timestamp)) {
            return true
        }
        
        return false
    }
    
    func save() -> Poem? {
        return Poem.dbSave(self) as Poem?
    }
    
    func delete() {
        if let _id = id {
            Poem.dbDelete(id: _id)
        }
    }
    
    func parents() -> [ParentComment] {
        if let _id = id {
            return ParentComment.getByPoemId(id: _id)
        }
        return []
    }
    
    func submission() -> Submission? {
        if let _id = id {
            return Submission.getByPoemId(id: _id)
        }
        return nil
    }
}
