//
//  NamedFace.swift
//  NamesToFaces
//
//  Created by Shae Willes on 7/15/21.
//

import SwiftUI

struct NamedFace: Identifiable, Codable, Comparable {
    enum CodingKeys: CodingKey {
        case id, face, name
    }
    
    let id: UUID
    var face: UIImage?
    var name: String
    
    init(id: UUID, face: UIImage?, name: String) {
        self.id = id
        self.face = face
        self.name = name
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        let jpegData = try container.decode(Data.self, forKey: .face)
        self.face = UIImage(data: jpegData, scale: 1.0)
        self.name = try container.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(face?.jpegData(compressionQuality: 0.8), forKey: .face)
        try container.encode(name, forKey: .name)
    }
    
    static func <(lhs: Self, rhs: Self) -> Bool {
        return lhs.name < rhs.name
    }
}
