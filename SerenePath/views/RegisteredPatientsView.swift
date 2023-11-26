//
//  RegisteredPatients.swift
//  VoiceTherapy
//
//  Created by Kushal P on 3/26/23.
//

import SwiftUI

import SwiftUI
import CoreData

struct RegisteredPatientsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    let changeView: (ViewType) -> Void
    @FetchRequest(entity: Patient.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Patient.username, ascending: true)],
                  animation: .default)
    var patients: FetchedResults<Patient>
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(hex: "#F1C9EC"), Color(hex: "#AB84CB")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Registered Patients")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                Text("Total Registered Patients \(patients.count)")

                List(patients) { patient in
                    Text(patient.username ?? "")
                        .foregroundColor(.white)
                        .padding()
                        .cornerRadius(10)
                }

                //.background(Color.clear)
                .listStyle(PlainListStyle())
                
                Button("Back to main") {
                    changeView(.main)
                }
                .foregroundColor(.white)
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(15.0)
                .frame(width: 220, height: 60)
                .padding()
            }.background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
        }
    }
}

/*
struct RegisteredPatientsView_Previews: PreviewProvider {
    static let viewContext = PersistenceController.preview.container.viewContext
    
    static func addDummyPatients() {
        let patient1 = Patient(context: viewContext)
        patient1.username = "john_doe"
        
        let patient2 = Patient(context: viewContext)
        patient2.username = "jane_doe"
        
        do {
            try viewContext.save()
        } catch {
            print("Error saving dummy patients: \(error.localizedDescription)")
        }
    }
    
    static var previews: some View {
        addDummyPatients()
        
        return RegisteredPatientsView(changeView: { _ in })
           .environment(\.managedObjectContext, viewContext)
    }
}


*/
