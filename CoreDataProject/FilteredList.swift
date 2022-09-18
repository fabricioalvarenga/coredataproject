//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by FABRICIO ALVARENGA on 29/08/22.
//

import CoreData
import SwiftUI

struct FilteredList<T: NSManagedObject, Content: View>: View {
    @FetchRequest var fetchRequest: FetchedResults<T>
    private let content: (T) -> Content

    private var predicateType: Predicate?
    private var sortDescriptors: [SortDescriptor<T>]
    
    var body: some View {
        List(fetchRequest, id: \.self) { item in
            self.content(item)
        }
    }

    init(_ filterKey: String? = nil, _ predicateType: Predicate? = nil, _ filterValue: String? = nil, sortDescriptors: [SortDescriptor<T>], @ViewBuilder content: @escaping (T) -> Content) {
        self.predicateType = predicateType
        self.sortDescriptors = sortDescriptors
        
        var predicate: NSPredicate? = nil
        
        if let key = filterKey {
            if let predic = predicateType {
                if let value = filterValue {
                    predicate = NSPredicate(format: "%K \(predic.rawValue) %@", key, value)
                }
            }
        }
        
        _fetchRequest = FetchRequest<T>(sortDescriptors: sortDescriptors, predicate: predicate)
        
        self.content = content
    }
}
