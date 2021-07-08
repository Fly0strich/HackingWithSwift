//
//  ContentView.swift
//  ActivityTracker
//
//  Created by Shae Willes on 6/3/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var activities = Activities()
    @State private var showingAddActivity = false
    
    var body: some View {
        NavigationView {
            List(activities.activityList) { activity in
                NavigationLink(destination: ActivityDetailsView(activity: activity)) {
                    Text(activity.name)
                }
            }
            .navigationBarTitle("Your Activities")
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                self.showingAddActivity = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddActivity) {
                AddActivityView(activities: activities)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
