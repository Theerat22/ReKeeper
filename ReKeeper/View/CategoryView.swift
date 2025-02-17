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
    @State private var isAddPlaceSheetPresented: Bool = false

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        List {
            ForEach(viewModel.places[placeIndex].categories.indices, id: \ .self) { categoryIndex in
                NavigationLink(destination: ItemGridView(placeIndex: placeIndex, categoryIndex: categoryIndex, viewModel: viewModel)) {
                    Text(viewModel.places[placeIndex].categories[categoryIndex].name)
                }
            }
        }
        
        
        .navigationTitle(viewModel.places[placeIndex].name)
        
        Button(action: {
            isAddPlaceSheetPresented.toggle()
        }) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(gradient: Gradient(colors: [Color.pink, Color.purple]),
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing)
                    )
                    .frame(width: 70, height: 70)
                    .shadow(color: Color.pink.opacity(0.5), radius: 10, x: 0, y: 5)
                
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .font(.system(size: 30, weight: .bold))
            }
        }
        .padding(.bottom, 30)
        .sheet(isPresented: $isAddPlaceSheetPresented) {
            AddCategoryView(viewModel: viewModel, placeIndex: placeIndex)
                .cornerRadius(20)
        }
    }
}
