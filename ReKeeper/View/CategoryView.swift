//
//  CategoryView.swift
//  ReKeeper
//
//  Created by Theeratdolchat Chatchai on 16/2/2568 BE.
//

import SwiftUI

import SwiftUI

struct CategoryView: View {
    var placeIndex: Int
    @ObservedObject var viewModel: StorageViewModel
    @State private var isAddPlaceSheetPresented: Bool = false
    
    @State private var showDeleteAlert = false
    @State private var selectedCategoryIndex: Int?
    
    let columns = [
        GridItem(.flexible(), spacing: 7),
        GridItem(.flexible(), spacing: 7),
        GridItem(.flexible(), spacing: 7)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                if let categories = getCategories() {
                    ForEach(categories.enumerated().map({ $0 }), id: \.element.id) { (index, category) in
                        NavigationLink(destination: ItemGridView(placeIndex: placeIndex, categoryIndex: index, viewModel: viewModel)) {
                            VStack {
                                Image(systemName: category.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.pink)
                                    .frame(width: 40, height: 40)
                                Text(category.name)
                                    .foregroundColor(.primary)
                            }
                            .frame(width: 100, height: 100)
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(PlainButtonStyle())
                        .onLongPressGesture {
                            selectedCategoryIndex = index
                            showDeleteAlert = true
                        }
                    }
                    .alert("Delete Category?", isPresented: $showDeleteAlert) {
                        Button("Cancel", role: .cancel) {}
                        Button("Delete", role: .destructive) {
                            if let index = selectedCategoryIndex {
                                withAnimation {
                                    viewModel.removeCategory(from: placeIndex, at: index)
                                }
                            }
                        }
                    } message: {
                        Text("Are you sure you want to delete this category?")
                    }
                } else {
                    Text("No categories available")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .padding(.top, 20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(getPlaceName())
        
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
        .padding(.top, 20)
        .sheet(isPresented: $isAddPlaceSheetPresented) {
            AddCategoryView(viewModel: viewModel, placeIndex: placeIndex)
                .cornerRadius(20)
        }
    }
    
    private func getCategories() -> [Category]? {
        guard viewModel.places.indices.contains(placeIndex) else { return nil }
        return viewModel.places[placeIndex].categories
    }
    
    private func getPlaceName() -> String {
        guard viewModel.places.indices.contains(placeIndex) else { return "Unknown Place" }
        return viewModel.places[placeIndex].name
    }
}


