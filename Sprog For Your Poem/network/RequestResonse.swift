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
    private var hadError: Bool = false
    
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
    
    func withError() -> RequestResonse {
        self.hadError = true
        return self
    }
    
    func hasError() -> Bool {
        return self.hadError
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
    
    func getZippedSprogified() -> [SprogJson] {
        guard let dataIn = self.swiftResponse.data else {
            return []
        }
        
        guard let unzipped = Decompressor.decompress(data: dataIn) else {
            print("Failed to unzip poem data")
            return []
        }
        
        do {
            print(unzipped)
            return try JSONDecoder().decode([SprogJson].self, from: unzipped)
        } catch {
            print(error)
            
        }
        
        return []
    }
    
    func getSprogified() -> [SprogJson] {
        guard let dataIn = self.swiftResponse.data else {
            return []
        }
        
        do {
            print(dataIn)
            return try JSONDecoder().decode([SprogJson].self, from: dataIn)
        } catch {
            print(error)
        }
        
        return []
    }
    
    func finalize() -> RequestResonse {
        return self
    }
    
    func contentLength() -> Int64 {
        // if we successfully parse out a string from content-length it's actually an integer encoded as a string
        if let cL = getHeader(header: "Content-Length") as? String {
            return Int64(cL)!
        }
        
        return 0
    }
    
    func getHeader(header: String) -> Any? {
        if let allHeaders = self.headers {
            if let value = allHeaders[AnyHashable(header)] {
                return value
            }
        }
        
        return nil
    }
}
