//
//  LoginSuccessfulView.swift
//  VoiceTherapy
//
//  Created by Kushal P on 3/29/23.
//
import SwiftUI
import CoreData

struct LoginSuccessfulView: View {
    @Binding var loggedInUser: User?
    @State private var animationStart = false
    let changeView: (ViewType) -> Void
    @EnvironmentObject var viewModel: ViewModel
    @State private var showAppointmentView = false
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var currentView: ViewType
    
    private var user: User? {
        return loggedInUser
    }
    
    var body: some View {
        if showAppointmentView {
            AddAppointmentView(changeView: changeView)
                .environmentObject(viewModel)
                .environment(\.managedObjectContext, viewContext)
        } else {
            ZStack {
                // LinearGradient background
                LinearGradient(gradient: Gradient(colors: [Color(hex: "#FED9B7"), Color(hex: "#F07167")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .opacity(animationStart ? 1 : 0.7)
                    .animation(Animation.easeInOut(duration: 4).repeatForever(autoreverses: true), value: animationStart)

                // AngularGradient background
                AngularGradient(gradient: Gradient(colors: [Color.red, Color.orange, Color.yellow, Color.green, Color.blue, Color.purple, Color.red]), center: .center)
                    .opacity(animationStart ? 0.7 : 1)
                    .scaleEffect(animationStart ? 1.5 : 1)
                    .animation(Animation.easeInOut(duration: 4).repeatForever(autoreverses: true), value: animationStart)

                // Content
                VStack {
                    Text("Login Successful")
                        .font(.largeTitle)
                        .foregroundColor(.white)

                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    
                    VStack {
                        if let username = user?.username {
                            Text("Username: \(username)")
                                .foregroundColor(.white)
                                .padding()
                                .cornerRadius(10)
                        }

                        if let email = user?.email {
                            Text("Email: \(email)")
                                .foregroundColor(.white)
                                .padding()
                                .cornerRadius(10)
                        }

                        if let role = user?.role {
                            Text("Role: \(role)")
                                .foregroundColor(.white)
                                .padding()
                                .cornerRadius(10)
                        }

                        Button("Complete Profile") {
                            changeView(.profile)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(15.0)
                        .frame(width: 220, height: 60)
                        .padding()

                    if let role = user?.role, role == "Patient" {
                        Button("Schedule an Appointment") {
                            currentView = .appointment
                        }
                            .foregroundColor(.white)
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(15.0)
                            .frame(width: 220, height: 60)
                            .padding()
                        }
                        Button("View Appointments") {
                            currentView = .appointmentsview
                        }
                            .foregroundColor(.white)
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(15.0)
                            .frame(width: 220, height: 60)
                            .padding()
                        
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
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            self.animationStart.toggle()
        }
    }
}
}

struct LoginSuccessfulView_Previews: PreviewProvider {
    static var previews: some View {
        LoginSuccessfulView(loggedInUser: .constant(User()), changeView: { _ in }, currentView: .constant(.main))
            .environmentObject(ViewModel())
    }

}
