//
//  AddPlaceView.swift
//  ReKeeper
//
//  Created by Theeratdolchat Chatchai on 16/2/2568 BE.
//

import SwiftUI

struct AddPlaceView: View {
    @StateObject var viewModel = StorageViewModel()
    
    @State var placeName = ""
    
    var body : some View {
        NavigationStack{
            List{
                TextField("Place Name", text: $placeName)
            }
            .navigationTitle("Add Place")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem{
                    Button("Add"){
                        viewModel.addPlace(name: placeName)
                    }
                }
            }
        }
    }
}

#Preview {
    AddPlaceView()
}
