import SwiftUI
import SwiftData

@main
struct HeroRxApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            Medication.self,
            Diagnosis.self,
            Appointment.self
        ])
    }
}
