//
//  search.swift
//  Avestal
//
//  Created by Michael Safir on 28.05.2021.
//

import Foundation
import SwiftUI

struct SearchBarAvestal: View {
    @Binding var text: String
    
    @State var becomeFirstResponder = false
    @State private var isEditing = false
    @State var TitleString: String = "Поиск заказов"
    @State var ImageString: String = "magnifyingglass"
    
    var body: some View {
        HStack {
            
            TextField(TitleString, text: $text)
                .padding(10)
                .font(.custom("GolosText-Regular", size: 16))
                .padding(.leading, 25)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(15)
                .overlay(
                    HStack {
                        Image(systemName: ImageString)
                            .foregroundColor(.secondary)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 10)
                        
                        
                    }
                )
            
            
        }
    }
}
