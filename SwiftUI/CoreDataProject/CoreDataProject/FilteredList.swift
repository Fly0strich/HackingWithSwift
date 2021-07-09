//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by Shae Willes on 6/10/21.
//

import CoreData
import SwiftUI

struct FilteredList<T: NSManagedObject, Content: View>: View {
    let content: (T) -> Content
        
    var fetchRequest: FetchRequest<T>
    
    var fetchedResults: FetchedResults<T> {
        fetchRequest.wrappedValue
    }
    
    enum PredicateType: String {
        case lessThan = "<"
        case lessThanOrEqualTo = "<="
        case greaterThan = ">"
        case greaterThanOrEqualTo = ">="
        case equalTo = "=="
        case beginsWith = "BEGINSWITH"
        case endsWith = "ENDSWITH"
        case contains = "CONTAINS"
    }
    
    var body: some View {
        List(fetchedResults, id: \.self) { result in
            self.content(result)
        }
    }
    
    init(sortDescriptors: [NSSortDescriptor], filterKey: String, filterPredicate: PredicateType, filterValue: String,
         @ViewBuilder content: @escaping(T) -> Content) {
        self.content = content
        
        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: sortDescriptors, predicate: NSPredicate(format: "%K \(filterPredicate.rawValue) %@", filterKey, filterValue))
    }
}
