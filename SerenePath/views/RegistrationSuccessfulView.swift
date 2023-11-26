//
//  RegistrationSuccessfulView.swift
//  VoiceTherapy
//
//  Created by Kushal P on 3/26/23.
//
import SwiftUI
struct RegistrationSuccessfulView: View {
    @State private var animationStart = false
    @EnvironmentObject var viewModel: ViewModel
    let registeredUser: User
    let changeView: (ViewType) -> Void
    @State private var showAppointmentView = false

    var body: some View {
        if showAppointmentView {
            AddAppointmentView(changeView: changeView)
                .environmentObject(viewModel)

        } else {
            ZStack {
                // LinearGradient background
                LinearGradient(gradient: Gradient(colors: [Color(hex: "#FED9B7"), Color(hex: "#F07167")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .opacity(animationStart ? 1 : 0.7)
                    .animation(Animation.easeInOut(duration: 4).repeatForever(autoreverses: true), value: animationStart)

                // AngularGradient background
                AngularGradient(gradient: Gradient(colors: [Color(hex: "6157FF"), Color(hex: "EE49FD"), Color(hex: "103CE7"), Color(hex: "EE49FD"), Color(hex: "#7028E4"), Color(hex: "#DA22FF"), Color(hex: "#F1C9EC")]), center: .center)
                    .opacity(animationStart ? 0.7 : 1)
                    .scaleEffect(animationStart ? 1.5 : 1)
                    .animation(Animation.easeInOut(duration: 4).repeatForever(autoreverses: true), value: animationStart)

                // Content
                VStack {
                    Text("Registration Successful")
                        .font(.largeTitle)
                        .foregroundColor(.white)

                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                        .padding(.top, 10)

                    VStack {
                        Text("Username: \(registeredUser.username ?? "")")
                            .foregroundColor(.white)
                            .padding()
                            .cornerRadius(10)

                        Text("Email: \(registeredUser.email ?? "")")
                            .foregroundColor(.white)
                            .padding()
                            .cornerRadius(10)

                        Text("Role: \(registeredUser.role == "Therapist" ? "Therapist" : "Patient")")
                            .foregroundColor(.white)
                            .padding()
                            .cornerRadius(10)
                        
                        Button("Complete Profile") {
                            changeView(.profile)
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



struct RegistrationSuccessfulView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationSuccessfulView(registeredUser: User(), changeView: { _ in })
    }
}


