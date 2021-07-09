//
//  MissionView.swift
//  Moonshot
//
//  Created by Shae Willes on 5/28/21.
//

import SwiftUI

struct MissionView: View {
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
    let mission: Mission
    let astronauts: [CrewMember]
    let allAstronauts: [Astronaut]
    let allMissions: [Mission]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geometry.size.width * 0.7)
                        .padding(.top)
                    
                    Text(mission.formattedLaunchDate)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .padding()
                    
                    Text(mission.description)
                        .padding()
                    
                    ForEach(astronauts, id: \.role) { crewMember in
                        NavigationLink(destination: AstronautView(astronaut: crewMember.astronaut, astronauts: allAstronauts,
                                                                  missions: allMissions)) {
                            HStack {
                                Image(crewMember.astronaut.id)
                                    .resizable()
                                    .frame(width: 83, height: 60)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.secondary, lineWidth:1))
                                
                                VStack(alignment: .leading) {
                                    Text(crewMember.astronaut.name)
                                        .font(.headline)
                                    
                                    Text(crewMember.role)
                                        .fontWeight(crewMember.role == "Commander" ? .bold : .regular)
                                        .foregroundColor(crewMember.role == "Commander" ? .blue : .secondary)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }

                    Spacer(minLength: 25)
                }
            }
        }
        .navigationBarTitle(Text(mission.displayName), displayMode: .inline)
    }
    
    init(mission: Mission, astronauts: [Astronaut], missions:[Mission]) {
        self.mission = mission
        
        var matches = [CrewMember]()
        
        for crewMember in mission.crew {
            if let match = astronauts.first(where: {$0.id == crewMember.name}) {
                matches.append(CrewMember(role: crewMember.role, astronaut: match))
            } else {
                fatalError("Missing \(crewMember)")
            }
        }
        
        self.astronauts = matches
        
        self.allAstronauts = astronauts
        
        self.allMissions = missions
    }
}

struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        MissionView(mission: missions[0], astronauts: astronauts, missions: missions)
    }
}
