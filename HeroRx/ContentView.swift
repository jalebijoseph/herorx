import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house")
                }

            DiagnosesView()
                .tabItem {
                    Label("Conditions", systemImage: "heart.text.square")
                }

            MedicationView()
                .tabItem {
                    Label("Meds", systemImage: "pills")
                }
            AppointmentView()
                .tabItem {
                    Label("Appointments", systemImage: "calendar")
                }
            
            Text("Care Team")
                .tabItem {
                    Label("Care Team", systemImage: "person.2")
                }

            Text("Emergency")
                .tabItem {
                    Label("Emergency", systemImage: "cross.case.fill")
                }
        }
    }
}
