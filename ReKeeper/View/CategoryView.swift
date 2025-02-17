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
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.places[placeIndex].categories.indices, id: \ .self) { categoryIndex in
                    NavigationLink(destination: ItemGridView(placeIndex: placeIndex, categoryIndex: categoryIndex, viewModel: viewModel)) {
                        VStack {
                            Image(systemName: "shoe.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.pink)
                                .frame(width: 40, height: 40)
                            Text("Shoe")
                        }
                        .frame(width: 100, height: 100)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.top,20)
        }
        .background(Color(.systemGroupedBackground))
        
        
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
        .padding(.top,20)
        .sheet(isPresented: $isAddPlaceSheetPresented) {
            AddCategoryView(viewModel: viewModel, placeIndex: placeIndex)
                .cornerRadius(20)
        }
    }
}
