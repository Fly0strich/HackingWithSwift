//
//  Activities.swift
//  ActivityTracker
//
//  Created by Shae Willes on 6/3/21.
//

import Foundation

class Activities: ObservableObject {
    @Published var activityList = [Activity]() {
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(activityList) {
                UserDefaults.standard.set(encoded, forKey: "Activities")
            }
        }
    }
    
    init() {
        if let activityList = UserDefaults.standard.data(forKey: "Activities") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Activity].self, from: activityList) {
                self.activityList = decoded
                return
            }
        }
        self.activityList = []
    }
}
