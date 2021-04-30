//
//  scanner_preview.swift
//  Yelm.ProjectX
//
//  Created by Michael Safir on 28.04.2021.
//


import Foundation
import SwiftUI
import Yelm_Server



struct ScannerPreview: View {
    
    @State var selection: String? = nil

    
    var body: some View{
        VStack{
            
            HStack{
                Text("Управление")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                
                Spacer()
            }
            .padding(.leading, 15)
            
            
        }.padding(.bottom)
    }
    
}

