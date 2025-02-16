//
//  ItemGridView.swift
//  ReKeeper
//
//  Created by Theeratdolchat Chatchai on 16/2/2568 BE.
//

import SwiftUI
import PhotosUI

struct ItemGridView: View {
    var placeIndex: Int
    var categoryIndex: Int
    @ObservedObject var viewModel: StorageViewModel
    @State private var isShowingPhotoPicker = false
    @State private var inputImage: UIImage?
    @State private var newItemName = ""
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.places[placeIndex].categories[categoryIndex].items) { item in
                        VStack {
                            Image(uiImage: item.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                            Text(item.name)
                                .font(.caption)
                        }
                    }
                }
            }
            
            Button("Add Item") {
                isShowingPhotoPicker = true
            }
//            .sheet(isPresented: $isShowingPhotoPicker) {
//                ImagePicker(image: $inputImage) { image in
//                    if let newImage = image {
//                        viewModel.addItem(to: categoryIndex, in: placeIndex, name: newItemName, image: newImage)
//                    }
//                }
//            }
            
            Button("Find Similar Item") {
                if let image = inputImage, let foundItem = viewModel.findSimilarItem(image: image) {
                    print("Found similar item: \(foundItem.name)")
                } else {
                    print("No similar item found")
                }
            }
        }
        .navigationTitle(viewModel.places[placeIndex].categories[categoryIndex].name)
    }
}
