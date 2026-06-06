import Foundation
import SwiftData

@Model
class Medication {
    var name: String
    var dosage: String
    var time: Date
    var frequency: String
    var selectedDays: String
    var critical: Bool

    init(
        name: String,
        dosage: String,
        time: Date,
        frequency: String = "Once daily",
        selectedDays: String = "",
        critical: Bool = false
    ) {
        self.name = name
        self.dosage = dosage
        self.time = time
        self.frequency = frequency
        self.selectedDays = selectedDays
        self.critical = critical
    }
}
