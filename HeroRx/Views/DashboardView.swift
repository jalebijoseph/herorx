import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    VStack(alignment: .leading) {
                        Text("Today's Priorities")
                            .font(.title2)
                            .bold()

                        Text("3 High Priority Tasks")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(20)

                    VStack(alignment: .leading) {
                        Text("Upcoming Appointment")
                            .font(.headline)

                        Text("Neurology Checkup")
                        Text("June 10 • 2:00 PM")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(20)

                    VStack(alignment: .leading) {
                        Text("Medication Reminder")
                            .font(.headline)

                        Text("Keppra 500mg")
                        Text("Due in 2 hours")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(20)
                }
                .padding()
            }
            .navigationTitle("HeroRx")
        }
    }
}//
//  DashboardView.swift
//  HeroRx
//
//  Created by Scholar on 6/6/26.
//

