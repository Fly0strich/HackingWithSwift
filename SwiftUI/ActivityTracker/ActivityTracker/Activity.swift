//
//  Activity.swift
//  ActivityTracker
//
//  Created by Shae Willes on 6/3/21.
//

import Foundation

struct Activity: Identifiable, Codable {
    var id = UUID()
    var name: String
    var description: String
}
