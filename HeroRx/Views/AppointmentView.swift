import SwiftUI
import SwiftData

struct AppointmentView: View {

    @Environment(\.modelContext) private var context

    @Query(sort: \Appointment.date)
    private var appointments: [Appointment]

    @State private var title = ""
    @State private var doctorName = ""
    @State private var specialty = ""
    @State private var purpose = ""
    @State private var date = Date()
    @State private var location = ""
    @State private var prepNotes = ""
    @State private var questions = ""
    @State private var followUpNotes = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Add Appointment")
                            .font(.headline)

                        TextField("Appointment title", text: $title)
                            .textFieldStyle(.roundedBorder)

                        TextField("Doctor name", text: $doctorName)
                            .textFieldStyle(.roundedBorder)

                        TextField("Specialty, e.g. Neurology", text: $specialty)
                            .textFieldStyle(.roundedBorder)

                        TextField("Purpose of appointment", text: $purpose)
                            .textFieldStyle(.roundedBorder)

                        DatePicker("Date & Time", selection: $date)

                        TextField("Location", text: $location)
                            .textFieldStyle(.roundedBorder)

                        TextField("Prep notes", text: $prepNotes)
                            .textFieldStyle(.roundedBorder)

                        TextField("Questions to ask", text: $questions)
                            .textFieldStyle(.roundedBorder)

                        TextField("Follow-up notes", text: $followUpNotes)
                            .textFieldStyle(.roundedBorder)

                        Button("Add Appointment") {
                            addAppointment()
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))

                    LazyVStack(spacing: 14) {
                        ForEach(appointments) { appointment in
                            AppointmentCard(
                                appointment: appointment,
                                onDelete: {
                                    deleteAppointment(appointment)
                                },
                                onSave: {
                                    saveChanges()
                                }
                            )
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Appointments")
        }
    }

    private func addAppointment() {
        let appointment = Appointment(
            title: title.trimmingCharacters(in: .whitespaces),
            doctorName: doctorName.trimmingCharacters(in: .whitespaces),
            specialty: specialty.trimmingCharacters(in: .whitespaces),
            purpose: purpose.trimmingCharacters(in: .whitespaces),
            date: date,
            location: location.trimmingCharacters(in: .whitespaces),
            prepNotes: prepNotes.trimmingCharacters(in: .whitespaces),
            questions: questions.trimmingCharacters(in: .whitespaces),
            followUpNotes: followUpNotes.trimmingCharacters(in: .whitespaces)
        )

        context.insert(appointment)
        saveChanges()

        title = ""
        doctorName = ""
        specialty = ""
        purpose = ""
        date = Date()
        location = ""
        prepNotes = ""
        questions = ""
        followUpNotes = ""
    }

    private func deleteAppointment(_ appointment: Appointment) {
        context.delete(appointment)
        saveChanges()
    }

    private func saveChanges() {
        do {
            try context.save()
        } catch {
            print("Could not save appointment changes: \(error)")
        }
    }
}

struct AppointmentCard: View {

    @Bindable var appointment: Appointment

    let onDelete: () -> Void
    let onSave: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            HStack {
                VStack(alignment: .leading) {
                    Text(appointment.title)
                        .font(.headline)

                    Text(appointment.specialty.isEmpty ? "No specialty added" : appointment.specialty)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Button {
                    onDelete()
                } label: {
                    Image(systemName: "trash")
                }
                .foregroundStyle(.red)
            }

            DatePicker("Date", selection: $appointment.date)
                .onChange(of: appointment.date) {
                    onSave()
                }

            Text("Doctor: \(appointment.doctorName.isEmpty ? "Not added" : appointment.doctorName)")
                .font(.caption)

            Text("Purpose: \(appointment.purpose.isEmpty ? "Not added" : appointment.purpose)")
                .font(.caption)

            Text("Location: \(appointment.location.isEmpty ? "Not added" : appointment.location)")
                .font(.caption)
                .foregroundStyle(.secondary)

            if !appointment.prepNotes.isEmpty {
                Text("Prep: \(appointment.prepNotes)")
                    .font(.caption)
            }

            if !appointment.questions.isEmpty {
                Text("Questions: \(appointment.questions)")
                    .font(.caption)
            }

            if !appointment.followUpNotes.isEmpty {
                Text("Follow-up: \(appointment.followUpNotes)")
                    .font(.caption)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }
}
