//
//  String-CapitalizingFirstLetter.swift
//  Moonshot
//
//  Created by Shae Willes on 5/29/21.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
