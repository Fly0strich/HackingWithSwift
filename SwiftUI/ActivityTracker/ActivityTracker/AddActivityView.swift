//
//  AddActivityView.swift
//  ActivityTracker
//
//  Created by Shae Willes on 6/3/21.
//

import SwiftUI

struct AddActivityView: View {
    @ObservedObject var activities: Activities
    
    @Environment (\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var description = ""
    @State private var showingError = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Text("Name:")
                    TextField("Enter Here", text: $name)
                }
                
                HStack {
                    Text("Description:")
                    TextField("Enter Here", text: $description)
                }
            }
            .navigationBarTitle("Add A New Activity")
            .navigationBarItems(trailing: Button(action: {
                addItem()
            }) {
                Text("Done")
            })
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func addItem() {
        guard activities.activityList.first(where: {$0.name == name}) == nil else {
            addItemError(message: "An activity with the same name already exists.")
            return
        }
        
        guard name != "" else {
            addItemError(message: "Please enter a name for this activity")
            return
        }
        
        guard description != "" else {
            addItemError(message: "Please enter a description for this activity")
            return
        }
        
        activities.activityList.append(Activity(name: name, description: description))
        
        presentationMode.wrappedValue.dismiss()
    }
    
    func addItemError(title: String = "Activity Not Added:", message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

struct AddActivityView_Previews: PreviewProvider {
    static var previews: some View {
        AddActivityView(activities: Activities())
    }
}
