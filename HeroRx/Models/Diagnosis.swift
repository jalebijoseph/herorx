import Foundation
import SwiftData

@Model
class Diagnosis {
    var name: String
    var severity: String
    var conditionType: String

    init(
        name: String,
        severity: String,
        conditionType: String = "Chronic"
    ) {
        self.name = name
        self.severity = severity
        self.conditionType = conditionType
    }
}
