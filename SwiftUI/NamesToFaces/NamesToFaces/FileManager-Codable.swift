//
//  FileManager-Codable.swift
//  NamesToFaces
//
//  Created by Shae Willes on 7/24/21.
//

import Foundation

extension FileManager {
    enum CodableError: Error {
        case encodingError(description: String)
        case decodingError(description: String)
    }
    
    static func encode<T: Codable>(_ value: T, to file: String) throws {
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(value) else {
            throw CodableError.encodingError(description: "Unable to encode data")
        }
        
        let url = getDocumentsDirectory().appendingPathComponent(file)
        
        do {
            try encoded.write(to: url)
        } catch {
            throw CodableError.encodingError(description: "Unable to write data to \(file)")
        }
    }
    
    static func decode<T: Codable>(from file: String) throws -> T  {
        let url = getDocumentsDirectory().appendingPathComponent(file)
        guard let data = try? Data(contentsOf: url) else {
            throw CodableError.decodingError(description: "Unable to find \(file)")
        }
        
        let decoder = JSONDecoder()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            throw CodableError.decodingError(description: "Unable to decode \(file)")
        }
        
        return loaded
    }
    
    static func getDocumentsDirectory() -> URL {
        let paths = self.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
