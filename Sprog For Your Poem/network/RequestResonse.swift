//
//  RequestResonse.swift
//  sprog-for-your-poem
//
//  Created by Michael Albinson on 2021-07-10.
//

import Foundation

class RequestResonse {
    private var swiftResponse: SwiftResponse
    private var httpCode: Int = 0
    private var responseJSON: Any? = nil
    private var headers: [AnyHashable: Any]? = nil
    
    init(swiftResponse: SwiftResponse) {
        self.swiftResponse = swiftResponse
    }
    
    func withHeaders(headers: [AnyHashable: Any]) -> RequestResonse {
        self.headers = headers
        return self
    }
    
    func withHttpCode(httpCode: Int) -> RequestResonse {
        self.httpCode = httpCode
        return self
    }
    
    func getJsonData() -> Any? {
        // returned cached data if already parsed
        if nil != self.responseJSON {
            return self.responseJSON
        }
        
        // try to parse out the data
        if let dataIn = self.swiftResponse.data {
            let json = try? JSONSerialization.jsonObject(with: dataIn, options: [])
            self.responseJSON = json
            print(json ?? "JSON Response: empty")
            return self.responseJSON
        }
        
        return nil
    }
    
    func finalize() -> RequestResonse {
        return self
    }
    
    func getHeader(header: String) -> Any {
        if let allHeaders = self.headers {
            if let value = allHeaders[header] {
                return value
            }
        }
        
        return ""
    }
}
