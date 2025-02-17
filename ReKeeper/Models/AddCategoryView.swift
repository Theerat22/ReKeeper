//
//  AddCategoryView.swift
//  ReKeeper
//
//  Created by Theeratdolchat Chatchai on 17/2/2568 BE.
//

import SwiftUI

struct AddCategoryView: View {
    @ObservedObject var viewModel: StorageViewModel
    @State var CategoryName = ""
    var placeIndex: Int
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
            List{
                TextField("Category Name", text: $CategoryName)
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
            .navigationTitle("Add Category")
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
                        if !CategoryName.isEmpty {
                            viewModel.addCategory(to: placeIndex, name: CategoryName,icon:selectedIcon)
                            dismiss()
                        }
                    }
                    .disabled(CategoryName.isEmpty)
                }
            }
        }
    }
}

//#Preview {
//    AddCategoryView()
//}
