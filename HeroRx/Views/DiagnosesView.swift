import SwiftUI
import SwiftData

struct DiagnosesView: View {

    @Environment(\.modelContext) private var context

    @Query private var diagnoses: [Diagnosis]

    @State private var diagnosisName = ""
    @State private var selectedSeverity = "Medium"
    @State private var selectedConditionType = "Chronic"

    let severityOptions = ["Low", "Medium", "High", "Critical"]
    let conditionTypes = ["Chronic", "Short-term"]

    var sortedDiagnoses: [Diagnosis] {
        diagnoses.sorted {
            if $0.conditionType != $1.conditionType {
                return $0.conditionType == "Chronic"
            }
            return $0.name < $1.name
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Add Condition")
                            .font(.headline)

                        TextField("Example: Arthritis or Fever", text: $diagnosisName)
                            .textFieldStyle(.roundedBorder)

                        Picker("Type", selection: $selectedConditionType) {
                            ForEach(conditionTypes, id: \.self) { type in
                                Text(type).tag(type)
                            }
                        }
                        .pickerStyle(.menu)

                        Picker("Severity", selection: $selectedSeverity) {
                            ForEach(severityOptions, id: \.self) { severity in
                                Text(severity).tag(severity)
                            }
                        }
                        .pickerStyle(.menu)

                        Button("Add Diagnosis") {
                            addDiagnosis()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                        ForEach(sortedDiagnoses) { diagnosis in
                            DiagnosisCard(
                                diagnosis: diagnosis,
                                severityOptions: severityOptions,
                                conditionTypes: conditionTypes,
                                onDelete: { deleteDiagnosis(diagnosis) },
                                onSave: { saveChanges() }
                            )
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Diagnoses")
        }
    }

    private func addDiagnosis() {
        let trimmedName = diagnosisName.trimmingCharacters(in: .whitespaces)

        guard !trimmedName.isEmpty else { return }

        let diagnosis = Diagnosis(
            name: trimmedName,
            severity: selectedSeverity,
            conditionType: selectedConditionType
        )

        context.insert(diagnosis)
        saveChanges()

        diagnosisName = ""
        selectedSeverity = "Medium"
        selectedConditionType = "Chronic"
    }

    private func deleteDiagnosis(_ diagnosis: Diagnosis) {
        context.delete(diagnosis)
        saveChanges()
    }

    private func saveChanges() {
        do {
            try context.save()
        } catch {
            print("Could not save diagnosis changes: \(error)")
        }
    }
}

struct DiagnosisCard: View {

    @Bindable var diagnosis: Diagnosis

    let severityOptions: [String]
    let conditionTypes: [String]
    let onDelete: () -> Void
    let onSave: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            HStack {
                Text(diagnosis.name)
                    .font(.headline)
                    .lineLimit(2)

                Spacer()

                Button {
                    onDelete()
                } label: {
                    Image(systemName: "trash")
                }
                .foregroundStyle(.red)
            }

            Picker("Type", selection: $diagnosis.conditionType) {
                ForEach(conditionTypes, id: \.self) { type in
                    Text(type).tag(type)
                }
            }
            .pickerStyle(.menu)
            .onChange(of: diagnosis.conditionType) {
                onSave()
            }

            Picker("Severity", selection: $diagnosis.severity) {
                ForEach(severityOptions, id: \.self) { severity in
                    Text(severity).tag(severity)
                }
            }
            .pickerStyle(.menu)
            .onChange(of: diagnosis.severity) {
                onSave()
            }

            Text("\(diagnosis.conditionType) • \(diagnosis.severity)")
                .font(.caption)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding()
        .frame(height: 180)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }
}
