//
//  PoemLoader.swift
//  sprog-for-your-poem
//
//  Created by Michael Albinson on 2021-07-10.
//

import Foundation

class PoemLoader {
    static let URL_ROOT: String = "https://almoturg.com/"
    static let URL_60_DAY: String = "poems_60days.json.gz"
    static let URL_FULL: String = "poems.json"
    static let RELOAD_TIME: TimeInterval = 60 * 60 * 6 // 6 hours
    
    static func get60Days() {
        safeLoadCompressedPoemJson(urlPath: URL_ROOT + PoemLoader.URL_60_DAY)
    }
    
    static func getFull() {
        loadPoemJSON(urlPath: URL_ROOT + PoemLoader.URL_FULL)
    }
    
    static func peekPoems() {
        // no last check, we need to do a full load to check there's nothing new
        guard let lastCheck = PoemHeadResponse.getLast() else {
            get60Days()
            return
        }
        
        // we're trying to check again too early
        if (Double(lastCheck.timestamp) + RELOAD_TIME < Date().timeIntervalSince1970) {
            return
        }
        
        let request = Request(url: URL_ROOT + URL_60_DAY, method: .HEAD)
        request.exec() { response in
            // we'll just wait til the next cycle to try again
            if (response.hasError()) {
                print("Failed to make request to \(URL_ROOT + URL_60_DAY)")
                return
            }
            
            // cache the contentLength of the new call and clean up the old one
            lastCheck.delete()
            let _ = PoemHeadResponse(type: URL_60_DAY, contentLength: response.contentLength(), timestamp: Int64(Date().timeIntervalSince1970), id: nil)
                .save()

            // mismatch in contentLength means there are new poems to consume
            let nextContentLength = response.contentLength()
            if (nextContentLength != lastCheck.contentLength) {
                get60Days()
            }
        }
    }
    
    private static func loadPoemJSON(urlPath: String) {
        Request(url: urlPath, method: .GET).exec() { response in
            if (response.hasError()) {
                print("Failed to make request to \(urlPath)")
                return
            }
            
            for poem in response.getSprogified() {
                loadPoem(poem)
            }
        }
    }
    
    private static func loadPoem(_ poemMetadata: SprogJson) {
        print("Loading poem \(poemMetadata.link)")
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
            content: poemMetadata.orig_submission_content,
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
                score: parent.score,
                order: count
            ).save()
            count += 1
        }
    }
    
    private static func safeLoadCompressedPoemJson(urlPath: String) {
        Request(url: urlPath, method: .GET).exec() { response in
            for poem in response.getZippedSprogified() {
                if (Poem.poemLoaded(poemJson: poem)) {
                    continue
                }
                
                loadPoem(poem)
            }
        }
    }
}
