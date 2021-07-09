//
//  ContentView.swift
//  iExpense
//
//  Created by Shae Willes on 5/27/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.label)
                                .font(.headline)
                            
                            Text(item.type)
                        }
                        
                        Spacer()
                        
                        Text("$\(item.amount, specifier: "%.2f")")
                            .bold()
                            .foregroundColor(getAmountColor(amount: item.amount))
                    }
                }
                .onDelete(perform: expenses.removeItems)
            }
            .navigationBarTitle("iExpense")
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                self.showingAddExpense = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
    
    func getAmountColor(amount: Double) -> Color {
        let smallAmount = 10.0
        let mediumAmount = 100.0
        let largeAmount = 1000.0
        
        switch amount {
        case 0..<smallAmount:
            return Color.blue
        case smallAmount..<mediumAmount:
            return Color.green
        case mediumAmount..<largeAmount:
            return Color.orange
        default:
            return Color.red
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
