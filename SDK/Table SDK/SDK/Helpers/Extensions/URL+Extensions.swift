//
//  URL+Extensions.swift
//  Table SDK
//
//  Created by user on 21.08.2020.
//  Copyright © 2020 TableCO. All rights reserved.
//

import Foundation

extension URL {
    func withQueries(_ queries: [String : Any]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.compactMap { URLQueryItem(name: $0.0, value: $0.1 as? String) }
        if let replaces = components?.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B").replacingOccurrences(of: "%252B", with: "%2B") {
            components?.percentEncodedQuery = replaces
        }
        return components?.url
    }
    
    func getQueryValue(by key: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == key })?.value
    }
    
    public var queryParameters: [String: String]? {
            guard
                let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
                let queryItems = components.queryItems else { return nil }
            return queryItems.reduce(into: [String: String]()) { (result, item) in
                result[item.name] = item.value
            }
    }
}

extension URLRequest {
    
    private func percentEscapeString(_ string: Any) -> String {
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-._* ")
        
        return (string as AnyObject)
            .addingPercentEncoding(withAllowedCharacters: characterSet)!
            .replacingOccurrences(of: " ", with: "+")
            .replacingOccurrences(of: " ", with: "+", options: [], range: nil)
    }

    mutating func encodeParameters(parameters: [String : [Any]]) -> Data {
//        httpMethod = "POST"
        
        let parameterArray = parameters.map { (arg) -> String in
            let (key, values) = arg
            var stringsArray = [String]()
            for value in values {
                stringsArray.append("\(key)=\(value)")
            }
            let str = stringsArray.joined(separator: "&")
            return str
        }
        
        let str = parameterArray.joined(separator: "&")
        let d = str.data(using: .utf8)!
        
        return d
    }
}
