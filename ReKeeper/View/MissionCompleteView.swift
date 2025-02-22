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
    
    var body: some View {
        VStack {
            Text("Congratulations!")
                .font(.title)
                .bold()
                .padding()
            
            Image(systemName: "trophy")
                .foregroundColor(.pink)
                .font(.system(size: 150))
                .shadow(color: .pink.opacity(0.5), radius: 10, x: 0, y: 10)

            Text("You have completed")
                .font(.title2)
                .padding(.top, 10)
            
            Text("\(missionName)")
                .font(.title)
                .bold()
                .padding(.bottom, 20)
            
            Button(action: {
                shareImage()
            }) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title)
                    Text("Share & Save")
                        .font(.headline)
                }
                .padding()
                .background(Color.pink)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 10)
            }
            .padding(.top, 20)
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [.white, Color.pink.opacity(0.1)]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
    }
    
    private func shareImage() {
        let screenshot = captureScreenshot()
        let activityController = UIActivityViewController(activityItems: [screenshot], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityController, animated: true, completion: nil)
        }
    }

    private func captureScreenshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view!
        
        let size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
}

#Preview {
    MissionCompletionView(missionName: "Test Mission")
}

