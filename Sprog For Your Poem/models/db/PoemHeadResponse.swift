//
//  PoemHeadResponse.swift
//  Sprog For Your Poem
//
//  Created by Michael Albinson on 2/17/23.
//

import Foundation

struct PoemHeadResponse: Codable, DatabaseModel {
    let type: String
    let contentLength: Int64
    let timestamp: Int64
    let id: Int64?
    
    static func tableName() -> String {
        "PoemHeadResponses"
    }
    
    static func fields() -> [String : ColumnType] {
        return [
            "type": ColumnType.T_String,
            "contentLength": ColumnType.T_Int64,
            "timestamp": ColumnType.T_Int64
        ]
    }
    
    static func getLast() -> PoemHeadResponse? {
        let poemHeadResponses = PoemHeadResponse.dbGetAll() as [PoemHeadResponse]
        if poemHeadResponses.count > 0 {
            return poemHeadResponses[0]
        }
        
        return nil
    }
    
    func save() -> PoemHeadResponse? {
        return PoemHeadResponse.dbSave(self) as PoemHeadResponse?
    }
    
    func delete() {
        if let _id = self.id {
            return PoemHeadResponse.dbDelete(id: _id)
        }
    }
    
    static func deleteAll() {
        PoemHeadResponse.dangerouslyDeleteAll()
    }
}
