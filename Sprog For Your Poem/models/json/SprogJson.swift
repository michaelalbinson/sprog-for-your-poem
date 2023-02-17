//
//  SprogJson.swift
//  Sprog For Your Poem
//
//  Created by Michael Albinson on 2/17/23.
//

import Foundation

struct SprogJson: Decodable {
    let gold: Int
    let imgfilename: String?
    let link: String
    let noimg: Bool
    let orig_content: String
    let orig_submission_content: String
    let parents: [SprogParentComment]
    let platinum: Int
    let score: Int64
    let silver: Int
    let submission_title: String
    let submission_url: String?
    let submission_user: String
    let timestamp: Int64
    
    init(gold: Int?, imgfilename: String?, link: String?, noimg: Bool, orig_content: String?, orig_submission_content: String?, parents: [SprogParentComment]?, platinum: Int?, score: Int64?, silver: Int?, submission_title: String?, submission_url: String?, submission_user: String?, timestamp: Int64?) {
        self.gold = gold ?? 0
        self.imgfilename = imgfilename
        self.link = link ?? ""
        self.noimg = noimg
        self.orig_content = orig_content ?? ""
        self.orig_submission_content = orig_submission_content ?? ""
        self.parents = parents ?? []
        self.platinum = platinum ?? 0
        self.score = score ?? 0
        self.silver = silver ?? 0
        self.submission_title = submission_title ?? ""
        self.submission_url = submission_url ?? ""
        self.submission_user = submission_user ?? ""
        self.timestamp = timestamp ?? 0
    }
}
