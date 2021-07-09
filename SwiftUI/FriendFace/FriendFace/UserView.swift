//
//  UserView.swift
//  FriendFace
//
//  Created by Shae Willes on 6/16/21.
//

import SwiftUI

struct UserView: View {
    let user: User
    let allUsers: FetchedResults<User>
    @Environment(\.managedObjectContext) var viewContext
    
    
    var registrationDate: String {
        let registrationDateFormatter = DateFormatter()
        registrationDateFormatter.dateStyle = .short
        return registrationDateFormatter.string(from: user.wrappedRegistered)
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    Section {
                        Text("Basic Info")
                            .font(.title)
                        
                        Text(user.isActive ? "Active" : "Deactivated")
                            .foregroundColor(user.isActive ? .green : .red)
                            .fontWeight(.bold)
                        
                        HStack {
                            Text("Name:")
                                .fontWeight(.bold)
                            Spacer()
                            Text(user.wrappedName)
                        }
                        
                        HStack {
                            Text("Age:")
                                .fontWeight(.bold)
                            Spacer()
                            Text("\(user.age)")
                        }
                        
                        HStack {
                            Text("Member Since:")
                                .fontWeight(.bold)
                            Spacer()
                            Text(registrationDate)
                        }
                    }
                    
                    Section {
                        Text("Contact Info")
                            .font(.title)
                        Text("Email:")
                            .fontWeight(.bold)
                        Text(user.wrappedEmail)
                        Text("Address:")
                            .fontWeight(.bold)
                        Text(user.wrappedAddress)
                    }
                    
                    Section {
                        Text("About")
                            .font(.title)
                        Text(user.wrappedAbout)
                    }
                    
                    Section {
                        Text("Tags")
                            .font(.title)
                        
                        HStack {
                            ForEach(user.tagArray, id: \.self) {tag in
                                Text(tag)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    
                    Section {
                        Text("Friends")
                            .font(.title)
                        List(user.friendArray) { friend in
                            NavigationLink(destination: UserView(user: allUsers.first(where: { $0.id == friend.id })!, allUsers: allUsers).environment(\.managedObjectContext, viewContext)) {
                                Text(friend.wrappedName)
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitle("User Info", displayMode: .inline)
    }
}

struct UserView_Previews: PreviewProvider {
    @FetchRequest(entity: User.entity(), sortDescriptors: []) static var users: FetchedResults<User>

    static var previews: some View {
        UserView(user: User(), allUsers: users)
    }
}
