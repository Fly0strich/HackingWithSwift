//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Shae Willes on 5/27/21.
//

import Foundation

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let label: String
    let type: String
    let amount: Double
}
