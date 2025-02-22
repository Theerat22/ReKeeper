//
//  NotiView.swift
//  ReKeeper
//
//  Created by Theeratdolchat Chatchai on 22/2/2568 BE.
//


import SwiftUI
import Charts

struct NotificationView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: StorageViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                    HStack {
                        if viewModel.streakCounter != 0 {
                            Image(systemName: "flame.circle.fill")
                                .foregroundColor(Color.pink)
                                .font(.system(size: 80, weight: .bold))
                                .frame(width: 100, height: 120)
                        } else {
                            Image(systemName: "flame.circle.fill")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 80, weight: .bold))
                                .frame(width: 100, height: 120)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Streak Count")
                                .font(.title)
                                .bold()
                            Text("\(viewModel.streakCounter) Day")
                                .font(.title)
                                .bold()
                        }
                        .padding()
                    }
                
                
                VStack {
                    PieChartView(missions: viewModel.missions, completedMissions: viewModel.rewards,viewModel: viewModel)
                        .frame(height: 200)
                        .padding()
                }
                
                List {
                    ForEach(viewModel.missions.sorted { $0.goal < $1.goal }) { mission in
                        let totalItems = viewModel.places.flatMap { $0.categories }.flatMap { $0.items }.count
                        let completedCount = min(totalItems, mission.goal)
                        let progress = Double(completedCount) / Double(mission.goal)
                        let isCompleted = viewModel.rewards.contains(mission.reward)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(mission.name)")
                                    .bold()
                                Text("\(totalItems)/\(mission.goal) items added")
                                    .font(.subheadline)
                            }
                            Spacer()
                            ZStack {
                                ProgressBar(progress: progress)
                                    .frame(width: 150, height: 10)
                                
                                if isCompleted {
                                    NavigationLink(destination: MissionCompletionView(missionName: mission.name)) {
                                        //                                    Image(systemName: "checkmark.circle.fill")
                                        //                                        .foregroundColor(.green)
                                    }
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Mission & Reward")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
}


struct ProgressBar: View {
    var progress: Double
    
    var body: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .frame(height: 8)
                .foregroundColor(Color.gray.opacity(0.3))
            
            Capsule()
                .frame(width: CGFloat(progress) * 150, height: 8)
                .foregroundColor(Color.green)
                .animation(.linear(duration: 0.5), value: progress)
        }
        .frame(width: 150)
    }
}


struct PieChartView: View {
    var missions: [Mission]
    var completedMissions: [String]
    @ObservedObject var viewModel: StorageViewModel
    
    var body: some View {
        let totalItems = viewModel.places.flatMap { $0.categories }.flatMap { $0.items }.count
        
        let currentMission = missions.first { totalItems < $0.goal }
        
        if let currentMission = currentMission {
            let completedCount = totalItems
            let totalCount = currentMission.goal
            let completedPercentage = Double(completedCount) / Double(totalCount)
            
            VStack {
                ZStack {
                    Circle()
                        .trim(from: 0, to: CGFloat(completedPercentage))
                        .stroke(Color.green, lineWidth: 20)
                        .rotationEffect(.degrees(-90))
                        .frame(width: 150, height: 150)
                        .animation(.easeInOut(duration: 0.5), value: completedPercentage)

                    Circle()
                        .trim(from: CGFloat(completedPercentage), to: 1)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 20)
                        .rotationEffect(.degrees(-90))
                        .frame(width: 150, height: 150)
                        .animation(.easeInOut(duration: 0.5), value: completedPercentage)
                    
                    Text("\(completedCount)/\(totalCount)")
                        .font(.title)
                        .bold()
                }
                HStack {
                    Text("Current Mission:")
                        .bold()
                    Text("\(currentMission.name)")
                        .foregroundColor(Color.primary)
                        .bold()
                }
                .padding(.top, 10)
            }
        } else {
            ZStack {
                Circle()
                    .stroke(Color.green, lineWidth: 20)
                    .rotationEffect(.degrees(-90))
                    .frame(width: 150, height: 150)
//                    .animation(.easeInOut(duration: 0.5))
                
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 20)
                    .rotationEffect(.degrees(-90))
                    .frame(width: 150, height: 150)
//                    .animation(.easeInOut(duration: 0.5))

                VStack {
                    Text("All Missions Completed!")
                        .font(.title)
                        .bold()
                    Text("You have completed all missions.")
                        .font(.caption)
                        .bold()
                }
            }
        }
    }
}


#Preview {
    NotificationView(viewModel: StorageViewModel())
}
