////
////  ItemGridView.swift
////  ReKeeper
////
////  Created by Theeratdolchat Chatchai on 16/2/2568 BE.
////
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
            Text("Hello")
        }
        .navigationTitle(viewModel.places[placeIndex].categories[categoryIndex].name)
    }
}
