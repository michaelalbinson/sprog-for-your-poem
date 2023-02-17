//
//  SprogParentComment.swift
//  Sprog For Your Poem
//
//  Created by Michael Albinson on 2/17/23.
//

import Foundation

class SprogParentComment: Codable {
    let author: String
    let gold: Int
    let link: String
    let orig_body: String
    var platinum: Int = 0
    let score: Int64
    var silver: Int = 0
    let timestamp: Int64
    
    init(author: String?, gold: Int?, silver: Int?, platinum: Int?, timestamp: Int64?, link: String?, orig_body: String?, id: Int64?, childPoemId: Int64?, order: Int?, score: Int64?) {
        self.author = author ?? ""
        self.gold = gold ?? 0
        self.silver = silver ?? 0
        self.platinum = platinum ?? 0
        self.timestamp = timestamp ?? 0
        self.link = link ?? ""
        self.orig_body = orig_body ?? ""
        self.score = score ?? 0
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.author = (try? container.decode(String.self, forKey: .author)) ?? ""
        self.link = (try? container.decode(String.self, forKey: .link)) ?? ""
        self.orig_body = (try? container.decode(String.self, forKey: .orig_body)) ?? ""
        self.timestamp = (try? container.decode(Int64.self, forKey: .timestamp)) ?? 0
        self.score = (try? container.decode(Int64.self, forKey: .score)) ?? 0
        self.gold = (try? container.decode(Int.self, forKey: .gold)) ?? 0
        self.platinum = (try? container.decode(Int.self, forKey: .platinum)) ?? 0
        self.silver = (try? container.decode(Int.self, forKey: .silver)) ?? 0
    }
}
