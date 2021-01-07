//
//  ContentView.swift
//  Yelm.ProjectX
//
//  Created by Michael on 07.01.2021.
//

import SwiftUI
import Yelm_Server



struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
        
            .onAppear{
                ServerAPI.system.auth()
            }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
