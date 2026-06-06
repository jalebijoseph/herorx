import SwiftUI
import SwiftData

struct MedicationView: View {

    @Environment(\.modelContext) private var context

    @Query(sort: \Medication.time)
    private var medications: [Medication]

    @State private var name = ""
    @State private var dosage = ""
    @State private var time = Date()
    @State private var frequency = "Once daily"
    @State private var selectedDays: [String] = []
    @State private var critical = false

    let frequencyOptions = [
        "Once daily",
        "Twice daily",
        "Three times daily",
        "Every other day",
        "Weekly",
        "Monthly",
        "As needed"
    ]

    let dayOptions = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Add Medication")
                            .font(.headline)

                        TextField("Medication name", text: $name)
                            .textFieldStyle(.roundedBorder)

                        TextField("Dosage, e.g. 500mg", text: $dosage)
                            .textFieldStyle(.roundedBorder)

                        DatePicker(
                            "Time",
                            selection: $time,
                            displayedComponents: .hourAndMinute
                        )

                        Picker("Frequency", selection: $frequency) {
                            ForEach(frequencyOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(.menu)

                        Text("Days")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        LazyVGrid(
                            columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ],
                            spacing: 8
                        ) {
                            ForEach(dayOptions, id: \.self) { day in
                                Button {
                                    toggleDay(day)
                                } label: {
                                    Text(day)
                                        .font(.caption)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                        .background(
                                            selectedDays.contains(day)
                                            ? Color.accentColor.opacity(0.2)
                                            : Color.gray.opacity(0.12)
                                        )
                                        .clipShape(
                                            RoundedRectangle(
                                                cornerRadius: 14,
                                                style: .continuous
                                            )
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                        }

                        Toggle("Critical medication", isOn: $critical)

                        Button("Add Medication") {
                            addMedication()
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 32,
                            style: .continuous
                        )
                    )

                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
                        spacing: 14
                    ) {
                        ForEach(medications) { medication in
                            MedicationCard(
                                medication: medication,
                                onDelete: {
                                    deleteMedication(medication)
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
            .navigationTitle("Medications")
        }
    }

    private func addMedication() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        let trimmedDosage = dosage.trimmingCharacters(in: .whitespaces)

        guard !trimmedName.isEmpty else { return }

        let medication = Medication(
            name: trimmedName,
            dosage: trimmedDosage,
            time: time,
            frequency: frequency,
            selectedDays: selectedDays.joined(separator: ", "),
            critical: critical
        )

        context.insert(medication)
        saveChanges()

        name = ""
        dosage = ""
        time = Date()
        frequency = "Once daily"
        selectedDays = []
        critical = false
    }

    private func deleteMedication(_ medication: Medication) {
        context.delete(medication)
        saveChanges()
    }

    private func saveChanges() {
        do {
            try context.save()
        } catch {
            print("Could not save medication changes: \(error)")
        }
    }

    private func toggleDay(_ day: String) {
        if selectedDays.contains(day) {
            selectedDays.removeAll { $0 == day }
        } else {
            selectedDays.append(day)
        }
    }
}

struct MedicationCard: View {

    @Bindable var medication: Medication

    let onDelete: () -> Void
    let onSave: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            HStack {
                Image(systemName: medication.critical ? "exclamationmark.triangle.fill" : "pills.fill")
                    .foregroundStyle(medication.critical ? .red : .primary)

                Spacer()

                Button {
                    onDelete()
                } label: {
                    Image(systemName: "trash")
                }
                .foregroundStyle(.red)
                .accessibilityLabel("Remove medication")
            }

            Text(medication.name)
                .font(.headline)
                .lineLimit(2)

            Text(medication.dosage.isEmpty ? "No dosage added" : medication.dosage)
                .font(.caption)
                .foregroundStyle(.secondary)

            DatePicker(
                "Time",
                selection: $medication.time,
                displayedComponents: .hourAndMinute
            )
            .labelsHidden()
            .onChange(of: medication.time) {
                onSave()
            }

            Text(medication.frequency)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(
                medication.selectedDays.isEmpty
                ? "No days selected"
                : medication.selectedDays
            )
            .font(.caption)
            .foregroundStyle(.secondary)

            Toggle("Critical", isOn: $medication.critical)
                .font(.caption)
                .onChange(of: medication.critical) {
                    onSave()
                }

            Spacer()
        }
        .padding()
        .frame(height: 230)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 28,
                style: .continuous
            )
        )
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }
}
