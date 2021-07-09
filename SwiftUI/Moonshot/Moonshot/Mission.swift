//
//  Mission.swift
//  Moonshot
//
//  Created by Shae Willes on 5/28/21.
//

import Foundation

struct Mission: Codable, Identifiable {
    struct CrewRole: Codable {
        let name: String
        let role: String
    }
    
    let id: Int
    let launchDate: Date?
    let crew: [CrewRole]
    let description: String
    
    var displayName: String {
        "Apollo \(id)"
    }
    
    var image: String {
        "apollo\(id)"
    }
    
    var formattedLaunchDate: String {
        if let launchDate = launchDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: launchDate)
        } else {
            return "Never Launched"
        }
    }
    
    var formattedCrewNames: String {
        var formatted = ""
        for crewMember in crew {
            formatted += crewMember.name.capitalizingFirstLetter() + "\n"
        }
        return formatted
    }
}
