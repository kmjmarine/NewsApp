//
//  MockNewsSearchManager.swift
//  KeywordNewsTests
//
//  Created by kmjmarine on 2022/05/30.
//

import Foundation
@testable import KeywordNews

final class MockSearchManager: NewsSearchManagerProtocol {
    var error: Error?
    var isCalledRequest = false
    
    func request(
        from keyword: String,
        start: Int,
        display: Int,
        completionHandler: @escaping ([News]) -> Void
    ) {
        isCalledRequest = true
        
        if error == nil {
            completionHandler([])
        }
    }
}
