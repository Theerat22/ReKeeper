//
//  SearchView.swift
//  ReKeeper
//
//  Created by Theeratdolchat Chatchai on 21/2/2568 BE.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: StorageViewModel
    @State private var searchText: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var filteredResults: [(item: Item, placeIndex: Int, categoryIndex: Int, itemIndex: Int)] {
        viewModel.places.enumerated().flatMap { placeIndex, place in
            place.categories.enumerated().flatMap { categoryIndex, category in
                category.items.enumerated()
                    .filter { $0.element.name.localizedCaseInsensitiveContains(searchText) }
                    .map { (item: $0.element, placeIndex: placeIndex, categoryIndex: categoryIndex, itemIndex: $0.offset) }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search item...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                if searchText.isEmpty {
                    Text("Enter item name to search")
                        .foregroundColor(.gray)
                } else if filteredResults.isEmpty {
                    Text("Not Found")
                        .foregroundColor(.red)
                } else {
                    List(filteredResults, id: \.item.id) { result in
                        NavigationLink(
                            destination: ItemGridView(
                                placeIndex: result.placeIndex,
                                categoryIndex: result.categoryIndex,
                                viewModel: viewModel)
//                            placeIndex: placeIndex, categoryIndex: index, viewModel: viewModel
                        ) {
                            HStack {
                                if let imageData = result.item.imageData, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                } else {
                                    Image(systemName: "photo")
                                        .frame(width: 40, height: 40)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(result.item.name)
                                        .font(.headline)
                                    Text("Stored in: \(viewModel.places[result.placeIndex].name)")
                                        .font(.subheadline)
                                        .foregroundColor(.pink)
                                    Text("Received: \(formattedDate(result.item.receivedDate))")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .navigationTitle("Search Items")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
