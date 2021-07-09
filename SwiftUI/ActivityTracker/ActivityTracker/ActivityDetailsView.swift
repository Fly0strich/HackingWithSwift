//
//  ActivityDetailsView.swift
//  ActivityTracker
//
//  Created by Shae Willes on 6/3/21.
//

import SwiftUI

struct ActivityDetailsView: View {
    let activity: Activity
    
    var body: some View {
        NavigationView {
            Text(activity.description)
        }
        .navigationBarTitle(activity.name)
    }
    
    init(activity: Activity) {
        self.activity = activity
    }
}

struct ActivityDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetailsView(activity: Activity(name: "Activity Name", description: "Description"))
    }
}
