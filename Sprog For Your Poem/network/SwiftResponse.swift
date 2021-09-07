//
//  SwiftResponse.swift
//  sprog-for-your-poem
//
//  Created by Michael Albinson on 2021-07-10.
//

import Foundation

class SwiftResponse {
    let data: Data?
    let response: URLResponse?
    let error: Error?
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
}
