//
//  WikipediaResult.swift
//  BucketList
//
//  Created by Shae Willes on 7/11/21.
//

import Foundation

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable {
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
}
