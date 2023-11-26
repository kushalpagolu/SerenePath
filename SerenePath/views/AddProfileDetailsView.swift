//
//  ProfileDetailsView.swift
//  VoiceTherapy
//
//  Created by Kushal P on 3/27/23.
//



import CoreData
import SwiftUI

struct AddProfileDetailsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var viewModel: ViewModel
    let changeView: (ViewType) -> Void
    let isTherapist: Bool
    let username: String
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var dateOfBirth: Date = Date()
    @State private var gender: String = ""
    @State private var contactNumber: String = ""

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(hex: "#4D6530"), Color(hex: "#C5C0A9")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text(isTherapist ? "Therapist Profile" : "Patient Profile")
                    .font(.largeTitle)
                    .padding(.bottom, 20)

                TextField("First Name", text: $firstName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                TextField("Last Name", text: $lastName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top)
                Text("Date of Birth")
                DatePicker(selection: $dateOfBirth, displayedComponents: .date) {
                        Text("Date of Birth")
                                }
                                .datePickerStyle(CompactDatePickerStyle())
                                .labelsHidden()
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .padding(.horizontal)
                                .padding(.top)
                                .onChange(of: dateOfBirth, perform: { value in
                print(dateFormatter.string(from: dateOfBirth))
                                })

                TextField("Gender", text: $gender)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top)

                TextField("Contact Number", text: $contactNumber)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top)

                Button(action: {
                    if viewModel.updateProfileDetails(viewContext: viewContext, username: username, firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, gender: gender, contactNumber: contactNumber, isTherapist: isTherapist) {
                        changeView(.successaapointment)
                    } else {
                        changeView(.error)
                    }
                }) {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .padding(.top)
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
        }
    }
}

struct AddProfileDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        AddProfileDetailsView(changeView: { _ in }, isTherapist: false, username: "Tester")
            .environmentObject(ViewModel())
    }
}
