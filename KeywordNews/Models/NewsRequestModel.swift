//
//  NewsRequestModel.swift
//  KeywordNews
//
//  Created by kmjmarine on 2022/05/24.
//

import Foundation

struct NewsRequestModel: Codable {
    let start: Int
    let display: Int
    let query: String
}
