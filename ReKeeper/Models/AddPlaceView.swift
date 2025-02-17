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
    @Environment(\.dismiss) var dismiss
    
    var body : some View {
        NavigationStack{
            List{
                TextField("Place Name", text: $placeName)
            }
            .navigationTitle("Add Place")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
                
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Add"){
                        if !placeName.isEmpty {
                            viewModel.addPlace(name: placeName)
                            dismiss()
                        }
                    }
                    .disabled(placeName.isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddPlaceView()
}
