//
//  ContentView.swift
//  ReKeeper
//
//  Created by Theeratdolchat Chatchai on 1/2/2568 BE.
//
//
import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = StorageViewModel()
    @State private var isAddPlaceSheetPresented: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.places.indices, id: \.self) { index in
                        NavigationLink(destination: CategoryView(placeIndex: index, viewModel: viewModel)) {
                            Text(viewModel.places[index].name)
                                .padding()
                        }
                    }
                }
                .navigationTitle("ReKeeper")
                
                Spacer()
                
                Button("+") {
                    isAddPlaceSheetPresented.toggle()
                }
                .padding()
            }
            .sheet(isPresented: $isAddPlaceSheetPresented) {
                AddPlaceView(viewModel: viewModel)
                    .cornerRadius(20)
            }
        }
    }
}

#Preview {
    ContentView()
}
