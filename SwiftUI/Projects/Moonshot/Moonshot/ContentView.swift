//
//  ContentView.swift
//  Moonshot
//
//  Created by Shae Willes on 5/28/21.
//

import SwiftUI

struct ContentView: View {
    @State private var showingCrewMembers = false

    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
            
    var body: some View {
        NavigationView {
            List(missions) { mission in
                
                let missionDetails = showingCrewMembers ? mission.formattedCrewNames : mission.formattedLaunchDate

                NavigationLink(destination: MissionView(mission: mission, astronauts: astronauts, missions: missions)) {
                    Image(mission.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 44, height: 44)
                    
                    VStack(alignment: .leading) {
                        Text(mission.displayName)
                            .font(.headline)
                        
                        Text(missionDetails)
                            .foregroundColor(.secondary)

                    }
                }
            }
            .navigationBarTitle("Apollo Missions")
            .navigationBarItems(trailing:
                Button(action: {
                    showingCrewMembers.toggle()
                }) {
                    Text(showingCrewMembers ? "Show Date" : "Show Crew")
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
