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
    @Environment(\.dismiss) var dismiss
    
    var body : some View {
        NavigationStack{
            List{
                TextField("Category Name", text: $CategoryName)
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
                            viewModel.addCategory(to: placeIndex, name: CategoryName)
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
