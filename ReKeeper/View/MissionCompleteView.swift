//
//  MissionCompleteView.swift
//  ReKeeper
//
//  Created by Theeratdolchat Chatchai on 22/2/2568 BE.
//

import SwiftUI

struct MissionCompletionView: View {
    var missionName: String
    @State private var isSharing = false
    @State private var screenshot: UIImage? = nil
    
    var body: some View {
        VStack {
            Text("Congratulations!")
                .font(.title)
                .bold()
                .padding()
                .foregroundColor(.white)
            
            Image(systemName: "trophy")
                .foregroundColor(.white)
                .font(.system(size: 150))
//                .shadow(color: .pink.opacity(0.5), radius: 10, x: 0, y: 10)

            Text("You have completed")
                .foregroundColor(.white)
                .font(.title2)
                .padding(.top, 10)
            
            Text("\(missionName)")
                .foregroundColor(.white)
                .font(.title)
                .bold()
                .padding(.bottom, 20)
            
        }
        .padding()
//        .background(LinearGradient(gradient: Gradient(colors: [.white, Color.pink.opacity(0.1)]), startPoint: .top, endPoint: .bottom))
        .background(.pink)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
    }

}

#Preview {
    MissionCompletionView(missionName: "Test Mission")
}

