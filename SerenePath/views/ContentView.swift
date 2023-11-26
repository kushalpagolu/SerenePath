//
//  ContentView.swift
//  SerenePath
//
//  Created by Kushal Pagolu on 4/6/23.
//

import SwiftUI
import CoreData

enum ViewType {
    case main
    case login
    case register
    case patients
    case users
    case profile
    case appointment
    case success
    case error
    case loggedinpatient
    case services
    case successaapointment
    case appointmentsview
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var currentView: ViewType = .main
    @EnvironmentObject var viewModel: ViewModel
    @State private var loggedInUser: User?
    
    var body: some View {
        content
    }
    
    private var content: some View {
        switch currentView {
        case .main:
            return AnyView(mainView)
            
        case .login:
            return AnyView(LoginView(changeView: changeView, loggedInUser: $loggedInUser, currentView: $currentView).environmentObject(viewModel)
                            .environment(\.managedObjectContext, viewContext))

        case .users:
            return AnyView(UserListView(changeView: changeView)
                            .environment(\.managedObjectContext, viewContext)
                            )
        case .register:
            return AnyView(RegistrationView(changeView: changeView)
                            .environment(\.managedObjectContext, viewContext)
                            )
        case .patients:
            return AnyView(RegisteredPatientsView(changeView: changeView)
                            .environment(\.managedObjectContext, viewContext)
                           )
             
        case .appointment:
            return AnyView(AddAppointmentView(changeView: changeView))
        case .profile:
            guard let loggedInUser = loggedInUser else {
                return AnyView(mainView)
            }
            return AnyView(AddProfileDetailsView(changeView: changeView, isTherapist: (loggedInUser.role != nil), username: loggedInUser.username!)
                            .environmentObject(viewModel)
                            .environment(\.managedObjectContext, viewContext))
            
        case .successaapointment:
            return AnyView(SuccessView(changeView: changeView)
                            .environmentObject(viewModel)
                            .environment(\.managedObjectContext, viewContext)
                      )
        case .appointmentsview:
            return AnyView(AppointmentsGridView(changeView: changeView)
                            .environmentObject(viewModel)
                            .environment(\.managedObjectContext, viewContext)
                      )
        case .success:
            guard loggedInUser != nil else {
                        return AnyView(mainView)
                    }
            return AnyView(LoginSuccessfulView(loggedInUser: $loggedInUser, changeView: changeView, currentView: $currentView)
                                    .environmentObject(viewModel)
                                    .environment(\.managedObjectContext, viewContext))
                
        case .services:
            return AnyView(ServicesListView(changeView: changeView)
                            .environment(\.managedObjectContext, viewContext)
                           )
        // Add cases for other view types similarly
        default:
            return AnyView(mainView)
        }
    }
    
    private var mainView: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(hex: "#DDEDB6"), Color(hex: "#969DD3")]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    let columns = [GridItem(.flexible()), GridItem(.flexible())]
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        cardButton(text: "Login Patient", systemImage: "person", action: { changeView(to: .login) })
                        cardButton(text: "Register", systemImage: "person.badge.plus", action: { changeView(to: .register) })
                        cardButton(text: "See Users", systemImage: "person.3", action: { changeView(to: .users) })
                        cardButton(text: "Show Services", systemImage: "list.dash", action: { changeView(to: .services) })
                        cardButton(text: "See Patients", systemImage: "person.2", action: { changeView(to: .patients) })
                        cardButton(text: "Add Appointment", systemImage:  "person.crop.circle.badge.plus", action: { changeView(to: .appointment) })
                        cardButton(text: "Complete Profile", systemImage: "person.crop.rectangle.stack.fill", action: { changeView(to: .profile) }).environmentObject(viewModel)
                    }
                    .padding()
                    .navigationBarTitle("", displayMode: .inline)
                    .navigationBarHidden(true)
                }
            }
        }
    }

    private func changeView(to view: ViewType) {
        withAnimation{
            currentView = view
        }
    }

    private func cardButton(text: String, systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack {
                Image(systemName: systemImage)
                    .font(.system(size: 48))
                    .foregroundColor(Color.white)
                Text(text)
                    .font(.title3)
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.mint.opacity(0.7))
            .cornerRadius(15)
        }
        .buttonStyle(ScaleButtonStyle())
    }

    struct ScaleButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
                .animation(.easeInOut(duration: 0.5), value: configuration.isPressed)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ViewModel())
    }
}
