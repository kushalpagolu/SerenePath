//
//  AppointmentFormView.swift
//  VoiceTherapy
//
//  Created by Kushal P on 3/27/23.
//
import SwiftUI
import CoreData
import Combine

struct AddAppointmentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var viewModel: ViewModel
    let changeView: (ViewType) -> Void
    @FetchRequest(entity: Patient.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Patient.firstName, ascending: true)])
    private var patients: FetchedResults<Patient>
    @FetchRequest(entity: Therapist.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Therapist.firstName, ascending: true)])
    private var therapists: FetchedResults<Therapist>
    
    @State private var appointmentDate: Date = Date()
    @State private var appointmentStartTime: Date = Date()
    @State private var appointmentEndTime: Date = Date()
    @State private var selectedTherapistIndex = 0
    @State private var patientObjectID: NSManagedObjectID?
    @State private var services: [Service] = []
    @State private var selectedServices: [Bool] = []
    @State private var showErrorView = false
    @State private var cancellables: Set<AnyCancellable> = []
    @State private var showErrorAlert = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(hex: "#0D4671"), Color(hex: "#92E1E2")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                if showErrorView {
                    ErrorView(changeView: changeView, errorMessage: errorMessage ?? "An error occurred while saving the appointment.")
                        .transition(.move(edge: .bottom))
                        .onAppear {
                            Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { _ in
                                withAnimation {
                                    changeView(.login)
                                }
                            }
                        }
                }
                else {
                    VStack {
                        Spacer()
                        DatePicker("Appointment Date", selection: $appointmentDate, displayedComponents: .date)
                        DatePicker("Start Time", selection: $appointmentStartTime, displayedComponents: .hourAndMinute)
                        DatePicker("End Time", selection: $appointmentEndTime, displayedComponents: .hourAndMinute)
                        Picker(selection: $selectedTherapistIndex, label: Text("Select Therapist")) {
                            ForEach(therapists.indices, id: \.self) { index in
                                Text("\((therapists[index].firstName?.isEmpty == false ? therapists[index].firstName : therapists[index].username) ?? "") \((therapists[index].lastName?.isEmpty == false ? therapists[index].lastName : therapists[index].username) ?? "")")
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()

                        Text("Select Services")
                            .font(.headline)
                        
                        List(0..<services.count, id: \.self) { index in
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.4)) {
                                    selectedServices[index].toggle()
                                }
                            }) {
                                HStack {
                                    Image(services[index].serviceImage ?? "placeholder")
                                        .resizable()
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 20)

                                    Text(services[index].name ?? "")
                                    Spacer()
                                    Toggle("", isOn: $selectedServices[index])
                                        .labelsHidden()
                                        .opacity(0)
                                }
                                .background(selectedServices[index] ? Color.green.opacity(0.6) : Color.clear)
                                .cornerRadius(8)
                            }
                        }
                        Button("Submit Appointment Request") {
                            if viewModel.loggedInUser?.role == "Patient" {
                                let result = viewModel.saveAppointment(
                                    viewContext: viewContext,
                                    appointmentDate: appointmentDate,
                                    appointmentStartTime: appointmentStartTime,
                                    appointmentEndTime: appointmentEndTime,
                                    selectedTherapistObjectID: therapists[selectedTherapistIndex].objectID,
                                    selectedServices: services.enumerated().compactMap { index, service in
                                        selectedServices[index] ? service : nil
                                    }
                                )
                                
                                switch result {
                                case .success:
                                    changeView(.successaapointment)
                                case .failure(let error):
                                    errorMessage = error.localizedDescription
                                    showErrorView = true
                                }
                            } else {
                                errorMessage = "Please login to book an appointment"
                                showErrorView = true
                                print("Changing to login view")
                               // changeView(.login)
                            }
                        }
                            .foregroundColor(.white)
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(15.0)
                            .frame(width: 220, height: 60)
                        Button("Back to main") {
                            changeView(.main)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(15.0)
                        .frame(width: 220, height: 60)
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadServices()
            viewModel.services.publisher
                .collect()
                .sink { services in
                    self.services = services
                    self.selectedServices = Array(repeating: false, count: services.count)
                }
                .store(in: &cancellables)
        }
    }
}

/*
// Preview is crashing
 
struct AddAppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ViewModel()
        viewModel.services = [
            // Add some static or mock services here
            ServicePreview(id: UUID(), name: "Mock Service 1", price: 100, serviceDescription: "Mock service description.", serviceDuration: 60, serviceImage: "emdrtherapy"),
            ServicePreview(id: UUID(), name: "Mock Service 2", price: 200, serviceDescription: "Mock service description.", serviceDuration: 90, serviceImage: "therapysession")
        ].map { preview in
            let service = Service(context: PersistenceController.preview.container.viewContext)
            service.id = preview.id
            service.name = preview.name
            service.price = preview.price
            service.serviceDescription = preview.serviceDescription
            service.serviceDuration = preview.serviceDuration
            return service
        }

        return AddAppointmentView(changeView: { _ in })
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(viewModel)
    }
}


*/
