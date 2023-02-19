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
}
