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
    @State private var selectedIcon = "house.fill"
    @State private var selectedCategory = "Room"

    @Environment(\.dismiss) var dismiss
    
    let iconCategories: [(category: String, icons: [String])] = [
        ("Room", ["house.fill"]),
        ("Living Room", ["sofa.fill"]),
        ("Bed Room", ["bed.double.fill"]),
        ("Bath Room", ["shower.fill"]),
        ("Kitchen", ["frying.pan.fill"])
    ]
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    
    var filteredIcons: [String] {
        return iconCategories.first(where: { $0.category == selectedCategory })?.icons ?? []
    }
    
    var body : some View {
        NavigationStack{
            List {
                TextField("Place Name", text: $placeName)
                Picker("Place Type", selection: $selectedCategory) {
                    ForEach(iconCategories.map { $0.category }, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(filteredIcons, id: \.self) { iconName in
                            VStack {
                                Image(systemName: iconName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(selectedIcon == iconName ? .pink : .gray)
                                    .padding()
                                    .background(selectedIcon == iconName ? Color.pink.opacity(0.2) : Color.clear)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .onTapGesture {
                                selectedIcon = iconName
                            }
                        }
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
                                viewModel.addPlace(name: placeName,icon: selectedIcon)
                                dismiss()
                            }
                        }
                        .disabled(placeName.isEmpty)
                    }
                }
            }
        }
    }
}
#Preview {
    AddPlaceView()
}
