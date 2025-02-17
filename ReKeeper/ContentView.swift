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
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            
                        }) {
                            Image(systemName:"camera.metering.partial")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button(action: {
                            
                        }) {
                            Image(systemName:"magnifyingglass")
//                                .foregroundColor(.black)
                        }
                    }
                }
                .navigationTitle("ReKeeper")
                
                Spacer()
                
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

