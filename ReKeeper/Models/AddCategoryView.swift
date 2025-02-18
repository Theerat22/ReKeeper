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
    @State private var selectedIcon = "tshirt.fill"
    @State private var selectedCategory = "Clothing"
    
    @Environment(\.dismiss) var dismiss
    
    let iconCategories: [(category: String, icons: [String])] = [
        ("Clothing", ["tshirt.fill", "shoe.fill", "handbag.fill", "eyeglasses"]),
        ("Food", ["carrot.fill", "takeoutbag.and.cup.and.straw.fill", "fork.knife"]),
        ("Accessories", ["watch.analog", "sparkles", "earbuds"]),
        ("Gadgets", ["iphone.gen3", "ipad.landscape", "laptopcomputer"]),
        ("Travel Items", ["suitcase.fill", "airplane", "map.fill"]),
        ("Office Supplies", ["pencil.and.ruler.fill", "doc.text.fill", "folder.fill"]),
        ("Entertainment", ["gamecontroller.fill", "headphones", "guitars.fill"]),
        ("Sports & Fitness", ["dumbbell.fill", "tennisball.fill", "figure.walk"]),
        ("Pets", ["pawprint.fill", "fish.fill", "teddybear.fill"]),
        ("Living Room", ["sofa.fill", "tv.fill", "speaker.fill"]),
        ("Bedroom", ["bed.double.fill", "lamp.fill", "curtains.closed"]),
        ("Bathroom", ["shower.fill", "bathtub.fill", "toilet.fill"]),
        ("Kitchen", ["frying.pan.fill", "cup.and.saucer.fill", "refrigerator.fill"]),
        ("Outdoors", ["tent.fill", "tree.fill", "sun.max.fill"]),
        ("Tools", ["hammer.fill", "wrench.fill", "screwdriver.fill"])
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
                Picker("Item Type", selection: $selectedCategory) {
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
}

//#Preview {
//    AddCategoryView()
//}
