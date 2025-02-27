//
//  ContentView.swift
//  ReKeeper
//
//  Created by Theeratdolchat Chatchai on 1/2/2568 BE.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = StorageViewModel()
    @State private var isAddPlaceSheetPresented: Bool = false
    @State private var isFindSimilarPresented: Bool = false
    @State private var isSearchPresented: Bool = false
    @State private var showNotification = false
    
    func deletePlace(at offsets: IndexSet) {
        for index in offsets {
            viewModel.removePlace(at: index)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.places.indices, id: \ .self) { index in
                        NavigationLink(destination: CategoryView(placeIndex: index, viewModel: viewModel)) {
                            HStack{
                                Image(systemName: viewModel.places[index].icon)
                                    .foregroundColor(.pink)
                                    .font(.title2)
                                Text(viewModel.places[index].name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                            }
                            .padding(.vertical, 10)
                        }
                        .padding()
                    }
                    .onDelete(perform: deletePlace)
                }
                .navigationTitle("ReKeeper")
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            isFindSimilarPresented.toggle()
                        }) {
                            Image(systemName:"camera.metering.partial")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button(action: {
                            isSearchPresented.toggle()
                        }) {
                            Image(systemName:"magnifyingglass")
                        }
                    }
                }

                Spacer()
                
                ZStack {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            showNotification.toggle()
                        }) {
                            Image(systemName: "bell.fill")
                                .font(.title)
                                .foregroundColor(.pink)
                        }
                        .padding(.top, 20)
                        .padding(.trailing, 20)
                    }
                    
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
                }
            }
        }
        .sheet(isPresented: $isFindSimilarPresented) {
            FindSimilar()
                .cornerRadius(20)
        }
        .sheet(isPresented: $isSearchPresented) {
            SearchView(viewModel: viewModel)
                .cornerRadius(20)
        }
        .sheet(isPresented: $isAddPlaceSheetPresented) {
            AddPlaceView(viewModel: viewModel)
                .cornerRadius(20)
        }
        .sheet(isPresented: $showNotification) {
            NotificationView(viewModel: viewModel)
        }
    }
}

#Preview {
    ContentView()
}
