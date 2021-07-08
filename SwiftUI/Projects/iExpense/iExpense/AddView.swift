//
//  AddView.swift
//  iExpense
//
//  Created by Shae Willes on 5/27/21.
//

import SwiftUI

struct AddView: View {
    @ObservedObject var expenses: Expenses
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingError = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var label = ""
    @State private var type = "Personal"
    @State private var amount = ""
    
    static let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Text("Label:")
                    
                    TextField("Enter Here", text: $label)
                }
                
                Picker("Type:", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                
                HStack {
                    Text("Amount: ")
                    
                    Text("$")
                        .foregroundColor(.gray)
                    
                    TextField("Enter Here", text: $amount)
                        .keyboardType(.numberPad)
                }
            }
            .navigationBarTitle("Add new expense")
            .navigationBarItems(trailing: Button("Save") {addItem()})
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("Ok")))
            }
        }
    }
    
    func addItem() {
        guard label != "" else {
            AddItemError(message: "Please enter a label for your expense")
            return
        }
        guard let actualAmount = Double(amount) else {
            AddItemError(message: "Please enter a valid dollar amount")
            return
        }
        let item = ExpenseItem(label: label, type: type, amount: actualAmount)
        expenses.items.append(item)
        presentationMode.wrappedValue.dismiss()
    }
    
    func AddItemError(title: String = "Item Not Added", message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
