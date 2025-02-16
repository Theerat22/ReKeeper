//
//  CategoryView.swift
//  ReKeeper
//
//  Created by Theeratdolchat Chatchai on 16/2/2568 BE.
//

import SwiftUI

struct CategoryView: View {
    var placeIndex: Int
    @ObservedObject var viewModel: StorageViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.places[placeIndex].categories.indices, id: \ .self) { categoryIndex in
                NavigationLink(destination: ItemGridView(placeIndex: placeIndex, categoryIndex: categoryIndex, viewModel: viewModel)) {
                    Text(viewModel.places[placeIndex].categories[categoryIndex].name)
                }
            }
        }
        .navigationTitle(viewModel.places[placeIndex].name)
        .toolbar {
            Button("+") {
                viewModel.addCategory(to: placeIndex, name: "New Category")
            }
        }
    }
}
