//
//  LocationRowView.swift
//  ReKeeper
//
//  Created by Theeratdolchat Chatchai on 16/2/2568 BE.
//

import SwiftUI

struct LocationRowView: View {
    
    @Binding var location: Place
    
    var body: some View {
        HStack {
            Image(systemName: "house.fill")
                .resizable()
                .frame(width: 60, height: 60)
            
            VStack(alignment: .leading) {
                Text(location.name)
                    .font(.headline)
                
            }
            Spacer()
        }
    }
}

#Preview {
    @Previewable @State var locationPreview = Place(name: "Home",categories:[])
    LocationRowView(location: $locationPreview)
}
