//
//  PoemLoader.swift
//  sprog-for-your-poem
//
//  Created by Michael Albinson on 2021-07-10.
//

import Foundation

class PoemLoader {
    static let URL_ROOT: String = ""
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
}
