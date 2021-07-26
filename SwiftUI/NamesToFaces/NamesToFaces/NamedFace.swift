//
//  NamedFace.swift
//  NamesToFaces
//
//  Created by Shae Willes on 7/15/21.
//

import SwiftUI

struct NamedFace: Identifiable, Codable, Comparable {
    enum CodingKeys: CodingKey {
        case id, face, name, locationMet
    }
    
    let id: UUID
    var face: UIImage?
    var name: String
    var locationMet: CodableMKPointAnnotation
    
    init(id: UUID, face: UIImage?, name: String, locationMet: CodableMKPointAnnotation) {
        self.id = id
        self.face = face
        self.name = name
        self.locationMet = locationMet
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        let jpegData = try container.decode(Data.self, forKey: .face)
        self.face = UIImage(data: jpegData, scale: 1.0)
        self.name = try container.decode(String.self, forKey: .name)
        self.locationMet = try container.decode(CodableMKPointAnnotation.self, forKey: .locationMet)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(face?.jpegData(compressionQuality: 0.8), forKey: .face)
        try container.encode(name, forKey: .name)
        try container.encode(locationMet, forKey: .locationMet)
    }
    
    static func <(lhs: Self, rhs: Self) -> Bool {
        return lhs.name < rhs.name
    }
}
