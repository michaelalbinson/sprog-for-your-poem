//
//  Request.swift
//  sprog-for-your-poem
//
//  Created by Michael Albinson on 2021-07-10.
//

import Foundation

class Request {
    static var DEFAULT_TIMEOUT: TimeInterval = 20
    
    private var url: String
    private var method: HttpMethod
    private var body: [String: Any]?
    private var objectifiedBody: SprogJson?
    
    init(url: String, method: HttpMethod) {
        self.url = url
        self.method = method
    }
    
    func withBody(body: [String: Any]?) -> Request {
        self.body = body
        return self
    }
    
    func exec(dataHandler: @escaping ((RequestResonse) -> Void)) {
        guard let request = setupRequest()
        else {
            return
        }

        puts("request out to \(String(describing: request.url))")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            let swiftResponse = SwiftResponse(data: data, response: response, error: error)
            self.handleResponse(swiftResponse: swiftResponse, dataHandler: dataHandler)
        }.resume()
    }
    
    private func handleResponse(swiftResponse: SwiftResponse, dataHandler: @escaping ((RequestResonse) -> Void)) {
        if let error = swiftResponse.error {
            dataHandler(
                RequestResonse(swiftResponse: swiftResponse)
                    .withError()
                    .finalize()
            )
            puts("request error \(error)")
            return
        }

        if let httpUrlResponse = swiftResponse.response as? HTTPURLResponse {
            dataHandler(
                RequestResonse(swiftResponse: swiftResponse)
                    .withHeaders(headers: httpUrlResponse.allHeaderFields)
                    .withHttpCode(httpCode: httpUrlResponse.statusCode)
                    .finalize()
            )
            return
        }
        
        dataHandler(
            RequestResonse(swiftResponse: swiftResponse)
                .finalize()
        )
    }
    
    
    private func setupRequest() -> URLRequest? {
        guard let serviceUrl = URL(string: self.url)
        else {
            return nil
        }
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = self.method.rawValue
        request.timeoutInterval = Request.DEFAULT_TIMEOUT
        
        if let body = self.body {
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            guard let httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
            else {
                // bail if we fail to serialize 
                return nil
            }

            request.httpBody = httpBody
        }
        
        return request
    }
}
