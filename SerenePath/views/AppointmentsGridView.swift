//
//  AppointmentGridView.swift
//  VoiceTherapy
//
//  Created by Kushal P on 4/1/23.
//
import SwiftUI
import CoreData

struct AppointmentsGridView: View {
    let changeView: (ViewType) -> Void
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Appointment.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Appointment.appointmentDate, ascending: true)],
        animation: .default
    )
    private var appointments: FetchedResults<Appointment>
    
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(hex: "#F1C9EC"), Color(hex: "#9B4EE9")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(Array(appointments.enumerated()), id: \.element) { index, appointment in
                            AppointmentCard(appointment: appointment, index: index)
                                .padding(4)
                        }
                    }
                    .padding()
                }
                Button("Back to main") {
                    changeView(.main)
                }
                .foregroundColor(.white)
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(15.0)
                .frame(width: 220, height: 60)
                .padding()
            }
            .navigationTitle("Appointments")
        }
    }
}

struct AppointmentCard: View {
    let appointment: Appointment
    let index: Int
    @State private var scale: CGFloat = 0.95
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Date: \(appointment.appointmentDate ?? Date(), formatter: dateFormatter)")
                    .foregroundColor(.white)
                Text("Start Time: \(appointment.appointmentTime ?? Date(), formatter: timeFormatter)")
                    .foregroundColor(.white)
                Text("End Time: \(appointment.appointmentEndTime ?? Date(), formatter: timeFormatter)")
                    .foregroundColor(.white)
                Text("Therapist: \(appointment.totherapist?.firstName ?? "") \(appointment.totherapist?.lastName ?? "")")
                    .foregroundColor(.white)
                Text("Patient: \(appointment.topatient?.firstName ?? "") \(appointment.topatient?.lastName ?? "")")
                    .foregroundColor(.white)
            }
            .padding()
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
        .cornerRadius(12)
        .scaleEffect(scale)
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        .onAppear {
            withAnimation(Animation.spring().delay(0.1 * Double(index))) {
                scale = 1.0
            }
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
}

struct AppointmentsGridView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentsGridView(changeView: { _ in })
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
