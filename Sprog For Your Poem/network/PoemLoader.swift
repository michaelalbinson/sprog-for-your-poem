//
//  PoemLoader.swift
//  sprog-for-your-poem
//
//  Created by Michael Albinson on 2021-07-10.
//

import Foundation

class PoemLoader {
    static let URL_ROOT: String = "https://almoturg.com/"
    static let URL_60_DAY: String = "poems_60days.json"
    static let URL_FULL: String = "poems.json"
    
    static func get60Days() {
        loadPoemJSON(urlPath: PoemLoader.URL_60_DAY)
    }
    
    static func getFull() {
        loadPoemJSON(urlPath: PoemLoader.URL_FULL)
    }
    
    static func peekPoems() {
        let request = Request(url: URL_60_DAY, method: .HEAD)
        request.exec() { response in
            
        }
    }
    
    private static func loadPoemJSON(urlPath: String) {
        Request(url: urlPath, method: .GET).withBody(body: nil).exec() { response in
            
        }
    }
    
    static func loadPoem(_ poemMetadata: SprogJson) {
        let poem = Poem(
            gold: poemMetadata.gold,
            platinum: poemMetadata.platinum,
            score: poemMetadata.score,
            link: poemMetadata.link,
            content: poemMetadata.orig_content,
            silver: poemMetadata.silver,
            timestamp: poemMetadata.timestamp,
            user: "sprog"
        ).save()!

        let _ = Submission(
            title: poemMetadata.submission_title,
            link: poemMetadata.link,
            user: poemMetadata.submission_user,
            content: poemMetadata.orig_content,
            poemId: poem.id!,
            id: nil
        ).save()

        var count = 0
        for parent in poemMetadata.parents {
            let _ = ParentComment(
                user: parent.author,
                gold: parent.gold,
                silver: parent.silver,
                platinum: parent.platinum,
                timestamp: parent.timestamp,
                link: parent.link,
                content: parent.orig_body,
                id: nil,
                childPoemId: poem.id!,
                order: count
            ).save()
            count += 1
        }
    }
}
