//
//  ContentView.swift
//  FriendFace
//
//  Created by Shae Willes on 6/11/21.
//

import SwiftUI
import CoreData



struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: User.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \User.name, ascending: true)]) var users: FetchedResults<User>
    
    var body: some View {
        NavigationView {
            List(users) { user in
                NavigationLink(destination: UserView(user: user, allUsers: users).environment(\.managedObjectContext, self.viewContext)) {
                    VStack {
                        HStack {
                            Text(user.wrappedName)
                            Spacer()
                            Text(user.wrappedCompany)
                        }
                    }
                }
            }
            .navigationBarTitle("All Users", displayMode: .inline)
            .onAppear(perform: loadUserData)
        }
    }
    
    func loadUserData() {
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let userData = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown Error")")
                return
            }
            
            let userDecoder = JSONDecoder()
            
            userDecoder.dateDecodingStrategy = .iso8601
            userDecoder.userInfo[CodingUserInfoKey.managedObjectContext] = viewContext
            
            guard let decodedData = try? userDecoder.decode([User].self, from: userData) else {
                print("Decoding Failed: \(error?.localizedDescription ?? "Unknown Error")")
                return
            }
            
            if !decodedData.isEmpty && viewContext.hasChanges {
                try? viewContext.save()
            }
            
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




