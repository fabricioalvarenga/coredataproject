//
//  ContentView.swift
//  CoreDataProject
//
//  Created by FABRICIO ALVARENGA on 29/08/22.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
//    @FetchRequest(sortDescriptors: []) var countries: FetchedResults<Country>
    
    @State private var filterKey: String? = nil
    @State private var predicateType: Predicate? = nil
    @State private var filterValue: String? = nil
    @State private var sortDescriptors =
    [
        SortDescriptor<Country>(\.fullName, order: .reverse)
    ]
    
    @State private var reversedOrder = false
    
    var body: some View {
        VStack {
            FilteredList(filterKey, predicateType, filterValue, sortDescriptors: sortDescriptors ) { (country: Country) in
                Section {
                    ForEach(getOrderedCandies(from: country.candyArray), id: \.self) { candy in
                        Text(candy.wrappedName)
                    }
                } header: {
                    Text(country.wrappedFullName)
                        .onTapGesture {
                            reversedOrder.toggle()
                        }
                }
            }
            
            Button("Add Examples") {
                let candy1 = Candy(context: moc)
                candy1.name = "Mars"
                candy1.origin = Country(context: moc)
                candy1.origin?.shortName = "UK"
                candy1.origin?.fullName = "United Kingdom"

                let candy2 = Candy(context: moc)
                candy2.name = "KitKat"
                candy2.origin = Country(context: moc)
                candy2.origin?.shortName = "UK"
                candy2.origin?.fullName = "United Kingdom"

                let candy3 = Candy(context: moc)
                candy3.name = "Twix"
                candy3.origin = Country(context: moc)
                candy3.origin?.shortName = "UK"
                candy3.origin?.fullName = "United Kingdom"

                let candy4 = Candy(context: moc)
                candy4.name = "Toblerone"
                candy4.origin = Country(context: moc)
                candy4.origin?.shortName = "CH"
                candy4.origin?.fullName = "Switzerland"
                
                try? moc.save()
            }
            
            Button("Filter None") {
                filterKey = nil
            }
            
            Button("Filter \"U\"") {
                filterKey = "fullName"
                predicateType = .beginsWith
                filterValue = "U"
            }
            
            Button("Filter \"S\"") {
                filterKey = "fullName"
                predicateType = .beginsWith
                filterValue = "S"
            }
        }
    }
    
    func getOrderedCandies(from candies: [Candy]) -> [Candy] {
        if !reversedOrder {
            return candies.sorted { $0.wrappedName < $1.wrappedName }
        } else {
            return candies.sorted { $0.wrappedName > $1.wrappedName }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
