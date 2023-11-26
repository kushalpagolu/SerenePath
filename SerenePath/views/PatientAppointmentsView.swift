//
//  AppointmentsListView.swift
//  VoiceTherapy
//
//  Created by Kushal P on 3/28/23.
//

import SwiftUI
import CoreData

struct PatientAppointmentsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Appointment.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Appointment.appointmentDate, ascending: true)],
                  animation: .default)
    private var appointments: FetchedResults<Appointment>
    
    let changeView: (ViewType) -> Void

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: "#F1C9EC"), Color(hex: "#AB84CB")], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack {
                Text("Appointments")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top)

                ScrollView {
                    LazyVStack {
                        ForEach(appointments) { appointment in
                            AppointmentRow(appointment: appointment)
                                .padding(.horizontal)
                        }
                    }
                }

                HStack(spacing: 20) {
                    Button {
                        withAnimation(.easeInOut) {
                            changeView(.appointment)
                        }
                    } label: {
                        Text("Add Appointment")
                    }
                    .buttonStyle(AnimatedButtonStyle())

                    Button {
                        withAnimation(.easeInOut) {
                            changeView(.main)
                        }
                    } label: {
                        Text("Back to Main")
                    }
                    .buttonStyle(AnimatedButtonStyle())
                }
                .padding(.bottom)
            }
        }
    }
}

struct AppointmentRow: View {
    let appointment: Appointment

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(appointment.appointmentDate ?? Date(), style: .date)
                .font(.headline)
                .foregroundColor(.white)
/*
            Text("Therapist: \(appointment.therapist?.firstName ?? "")")
                .foregroundColor(.white)
            Text("Therapist: \(appointment.therapist?.lastName ?? "")")
                .foregroundColor(.white)
 */
            Text("Services:")
                .foregroundColor(.white)

            ForEach(Array(appointment.toservice as? Set<Service> ?? []), id: \.self) { service in
                Text("• \(service.name ?? "")")
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(15)
        .padding(.bottom)
    }
}

struct AnimatedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(LinearGradient(colors: [Color.blue, Color.purple], startPoint: .leading, endPoint: .trailing))
            .cornerRadius(15)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}


struct PatientAppointmentsView_Previews: PreviewProvider {
    static var previews: some View {
        PatientAppointmentsView(changeView: { _ in })
    }
}
