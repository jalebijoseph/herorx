import Foundation
import SwiftData

@Model
class Appointment {
    var title: String
    var doctorName: String
    var specialty: String
    var purpose: String
    var date: Date
    var location: String
    var prepNotes: String
    var questions: String
    var followUpNotes: String

    init(
        title: String,
        doctorName: String,
        specialty: String,
        purpose: String,
        date: Date,
        location: String = "",
        prepNotes: String = "",
        questions: String = "",
        followUpNotes: String = ""
    ) {
        self.title = title
        self.doctorName = doctorName
        self.specialty = specialty
        self.purpose = purpose
        self.date = date
        self.location = location
        self.prepNotes = prepNotes
        self.questions = questions
        self.followUpNotes = followUpNotes
    }
}
