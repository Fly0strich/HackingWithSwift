//
//  FileManager-Decodable.swift
//  BucketList
//
//  Created by Shae Willes on 7/10/21.
//

import Foundation

extension FileManager {
    func decodeDocument<T: Codable>(_ file: String) -> T {
        let url = self.getDocumentsDirectory().appendingPathComponent(file)
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from Documents folder")
        }
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "y-MM-dd"
        
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from Documents folder")
        }
        
        return loaded
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
