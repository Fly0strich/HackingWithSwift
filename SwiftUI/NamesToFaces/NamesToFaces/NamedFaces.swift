//
//  NamedFaces.swift
//  NamesToFaces
//
//  Created by Shae Willes on 7/23/21.
//

import Foundation

class NamedFaces: ObservableObject {
    @Published var collection = [NamedFace]() {
        didSet {
            do {
                try FileManager.encode(collection, toFile: "NamedFaces.json")
            } catch FileManager.CodableError.encodingError(let description) {
                print(description)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
        
    init() {
        do {
            self.collection = try FileManager.decode(fromFile: "NamedFaces.json")
        } catch FileManager.CodableError.decodingError(let description) {
            print(description)
            self.collection = []
        } catch {
            print(error.localizedDescription)
            self.collection = []
        }
    }
        
    func removeItems(at offsets: IndexSet) {
        collection.remove(atOffsets: offsets)
    }
}

