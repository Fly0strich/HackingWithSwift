//
//  AstronautView.swift
//  Moonshot
//
//  Created by Shae Willes on 5/29/21.
//

import SwiftUI

struct AstronautView: View {    
    let astronaut: Astronaut
    let missions: [Mission]
    let allAstronauts: [Astronaut]
    let allMissions: [Mission]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)
                    
                    Text(astronaut.description)
                        .padding()
                    
                    ForEach(missions) { mission in
                        NavigationLink(destination: MissionView(mission: mission, astronauts: allAstronauts,
                                                                missions: allMissions)) {
                            HStack{
                                Image(mission.image)
                                    .resizable()
                                    .frame(width: 83, height: 60)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.secondary, lineWidth:1))
                                
                                VStack(alignment: .leading) {
                                    Text(mission.displayName)
                                        .font(.headline)
                                    
                                    Text(mission.formattedLaunchDate)
                                        .foregroundColor(.secondary)
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
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
    }
    
    init(astronaut: Astronaut, astronauts: [Astronaut], missions: [Mission]) {
        self.astronaut = astronaut
        
        var matches = [Mission]()
        
        for mission in missions {
            if mission.crew.first(where: {$0.name == astronaut.id}) != nil {
                matches.append(mission)
            }
        }
        
        self.missions = matches
        
        self.allAstronauts = astronauts
        
        self.allMissions = missions
    }
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    
    static var previews: some View {
        AstronautView(astronaut: astronauts[0], astronauts: astronauts, missions: missions)
    }
}
