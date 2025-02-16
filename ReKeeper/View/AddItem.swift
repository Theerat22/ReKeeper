//
//  AddItem.swift
//  ReKeeper
//
//  Created by Theeratdolchat Chatchai on 1/2/2568 BE.
//

import SwiftUI

struct AddItem: View {
    @State private var memoryName: String = ""
    @State private var giver = ""
    @State private var location = ""
    @State private var date = Date()
    @State private var capturedImage: UIImage?
    
    let givers = ["Bed","Living room"]
    
    var body: some View {
        VStack{
            
            Text("Add your Item")
            Spacer()
//            Image()
                .frame(width: 300, height: 300)
                .cornerRadius(10)
                .padding()
                
            TextField("Name", text: $memoryName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
//            Text("Giver")
            
            
            TextField("Giver", text: $giver)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            
            HStack {
                Text("Location")
                Spacer()
                
                Picker("Select Location", selection: $giver) {
                    ForEach(givers, id: \.self) { giver in
                        Text(giver).tag(giver)
                    }
                }
                .pickerStyle(MenuPickerStyle()) // แบบเมนู Dropdown
            }
            .padding()

            
            DatePicker("Date", selection: $date,displayedComponents: .date)
                .padding()
            
            
            Button(action: {
                saveMemory()
            }) {
                Text("Add your Memory")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.pink)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
                    .bold()
            }
            .padding()
        }
        .navigationTitle("Add memory")
        
    }
    
    func saveMemory() {
        
    }
}

#Preview {
    AddItem()
}
