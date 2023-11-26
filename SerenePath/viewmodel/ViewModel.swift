//
//  ViewModel.swift
//  VoiceTherapy
//
//  Created by Kushal P on 3/26/23.
//

import Foundation
import CoreData
import CloudKit

class ViewModel: ObservableObject{
    @Published var services: [Service] = []
    @Published var loggedInPatient: Patient?
    @Published var loggedInUser: User?
    {
    didSet {
                loggedInPatientDidChange?()
            }
        }
    var loggedInPatientDidChange: (() -> Void)?

    private var viewContext: NSManagedObjectContext
     
     init() {
         viewContext = PersistenceController.shared.container.viewContext
     }
    
    func loadServices() {
          let fetchRequest: NSFetchRequest<Service> = Service.fetchRequest()
          do {
              services = try viewContext.fetch(fetchRequest)
          } catch {
              print("Error fetching services: \(error)")
          }
      }
    
    func loadDefaultServices() {
        let fetchRequest: NSFetchRequest<Service> = Service.fetchRequest()

        do {
            let serviceCount = try viewContext.count(for: fetchRequest)
            if serviceCount > 0 {
                // Services already exist, just load them
                loadServices()
                return
            }
        } catch {
            print("Error counting services: \(error)")
        }

        // Add your default services here
        let defaultServices = [
            ServicePreview(id: UUID(), name: "Hypnosis", price: 200, serviceDescription: "A kool session involving hypno therapy.", serviceDuration: 60, serviceImage: "hypnosis"),
            ServicePreview(id: UUID(), name: "Therapy Session", price: 150, serviceDescription: "One on One session.", serviceDuration: 90, serviceImage: "therapysession"),
            ServicePreview(id: UUID(), name: "Online Therapy", price: 50, serviceDescription: "Let's chat over facetime, zoom or gtalk. You pick.", serviceDuration: 120, serviceImage: "onlinetherapy"),
            ServicePreview(id: UUID(), name: "Group Therapy", price: 40, serviceDescription: "Join a supportive group environment to share experiences and develop coping strategies.", serviceDuration: 120, serviceImage: "grouptherapy"),
            ServicePreview(id: UUID(), name: "Cognitive Behavioral Therapy", price: 80, serviceDescription: "Identify and change negative thought patterns and behaviors to improve mental well-being.", serviceDuration: 60, serviceImage: "cognitivetherapy"),
            ServicePreview(id: UUID(), name: "Family Therapy", price: 120, serviceDescription: "Strengthen family relationships and communication to create a supportive environment.", serviceDuration: 90, serviceImage: "familytherapy"),
            ServicePreview(id: UUID(), name: "Art Therapy", price: 70, serviceDescription: "Express emotions and thoughts through creative outlets such as drawing, painting, or sculpting.", serviceDuration: 90, serviceImage: "arttherapy"),
            ServicePreview(id: UUID(), name: "Mindfulness-Based Therapy", price: 60, serviceDescription: "Develop mindfulness skills to help manage stress, anxiety, and other mental health challenges.", serviceDuration: 75, serviceImage: "mindfultherapy"),
            ServicePreview(id: UUID(), name: "EMDR Therapy", price: 100, serviceDescription: "Use Eye Movement Desensitization and Reprocessing to process and alleviate traumatic memories.", serviceDuration: 90, serviceImage: "emdrtherapy"),
            ServicePreview(id: UUID(), name: "Psychoanalysis", price: 120, serviceDescription: "Gain deeper insight into the unconscious mind to address unresolved issues and improve mental health.", serviceDuration: 60, serviceImage: "psychoanalysis")

        ]

        for servicePreview in defaultServices {
            let service = Service(context: PersistenceController.shared.container.viewContext)
            service.id = servicePreview.id
            service.serviceImage = servicePreview.serviceImage
            service.name = servicePreview.name
            service.price = servicePreview.price
            service.serviceDescription = servicePreview.serviceDescription
            service.serviceDuration = servicePreview.serviceDuration
        }
        save()
        loadServices()
    }

    func save() {
            do {
                try PersistenceController.shared.container.viewContext.save()
            } catch {
                print("Error saving context: \(error.localizedDescription)")
            }
        }

    func registerUser(viewContext: NSManagedObjectContext, username: String, email: String, password: String, isTherapist: Bool = false) -> (success: Bool, user: User?) {
        // Ensure fields are not empty
        guard !username.isEmpty, !email.isEmpty, !password.isEmpty else {
            return (false, nil)
        }

        // Check for existing users with the same username
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)
        fetchRequest.fetchLimit = 1

        do {
            let existingUsers = try viewContext.fetch(fetchRequest)
            if !existingUsers.isEmpty {
                print("Username already exists.")
                return (false, nil)
            }
        } catch {
            print("Error fetching users: \(error.localizedDescription)")
            return (false, nil)
        }

        let user = User(context: viewContext)
        user.id = UUID()
        user.username = username
        user.email = email
        user.password = password

        if isTherapist {
            user.role = "Therapist"
        } else {
            user.role = "Patient"
        }

        var patient: Patient?

        if isTherapist {
            let therapist = Therapist(context: viewContext)
            therapist.username = username
            therapist.id = user.id
            therapist.email = email
            therapist.password = password
            therapist.role = "Therapist"
            therapist.user = user
            user.therapist = therapist
            // Set other properties for the therapist as needed, e.g. firstName, lastName, bio, etc.
        } else {
            patient = Patient(context: viewContext)
            patient?.id = user.id
            patient?.username = username
            patient?.email = email
            patient?.password = password
            patient?.role = "Patient"
            patient?.touser = user
            user.topatient = patient

            // Set other properties for the patient as needed, e.g. firstName, lastName, age, etc.
        }

        do {
            try viewContext.save()
            print("User registered successfully.")
            return (true, user)
        } catch {
            print("Error saving user: \(error.localizedDescription)")
            return (false, nil)
        }
    }
 
    func updateProfileDetails(viewContext: NSManagedObjectContext, username: String, firstName: String, lastName: String, dateOfBirth: Date, gender: String, contactNumber: String, isTherapist: Bool) -> Bool {
        guard !firstName.isEmpty, !lastName.isEmpty, !contactNumber.isEmpty, !gender.isEmpty else {
            return false
        }
        let userFetchRequest: NSFetchRequest<User> = User.fetchRequest()
        userFetchRequest.predicate = NSPredicate(format: "username == %@", username)
        userFetchRequest.fetchLimit = 1
        
        do {
            let users = try viewContext.fetch(userFetchRequest)
            if let user = users.first {
                user.firstName = firstName
                user.lastName = lastName
                user.dateOfBirth = dateOfBirth
                user.contactNumber = contactNumber
                if isTherapist {
                    user.therapist?.firstName = firstName
                    user.therapist?.lastName = lastName
                    user.therapist?.dateOfBirth = dateOfBirth
                    user.therapist?.gender = gender
                    user.therapist?.contactNumber = contactNumber
                    // Add other details for therapist if needed
                } else {
                    user.topatient?.firstName = firstName
                    user.topatient?.lastName = lastName
                    user.topatient?.dateOfBirth = dateOfBirth
                    user.topatient?.gender = gender
                    user.topatient?.contactNumber = contactNumber
                }
                
                do {
                    print("Profile updated successfully")
                    try viewContext.save()
                    return true
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return false
    }

    enum LoginError: Error {
        case invalidCredentials
        case fetchError(String)
    }
    
    func loginUser(viewContext: NSManagedObjectContext, username: String, password: String) -> Result<User, LoginError> {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)
        fetchRequest.fetchLimit = 1

        do {
            let existingUsers = try viewContext.fetch(fetchRequest)
            if !existingUsers.isEmpty {
                let loggedInUser = existingUsers[0]
                self.loggedInUser = loggedInUser // Set the loggedInUser property
                if loggedInUser.role == "Patient" {
                    let patientFetchRequest: NSFetchRequest<Patient> = Patient.fetchRequest()
                    patientFetchRequest.predicate = NSPredicate(format: "touser == %@", loggedInUser)
                    patientFetchRequest.fetchLimit = 1
                    
                    do {
                        let existingPatients = try viewContext.fetch(patientFetchRequest)
                        if !existingPatients.isEmpty {
                            self.loggedInPatient = existingPatients[0] // Set the loggedInPatient property
                            print("assigning the loggedInUser as loggedInPatient for appointment")
                        }
                    } catch {
                        return .failure(.fetchError(error.localizedDescription))
                    }
                }
                return .success(loggedInUser)
            } else {
                return .failure(.invalidCredentials)
            }
        } catch {
            return .failure(.fetchError(error.localizedDescription))
        }
    }

    func hasSavedDefaultServices() -> Bool {
        return UserDefaults.standard.bool(forKey: "hasSavedDefaultServices")
    }

    enum AppointmentError: Error {
        case patientNotFound
        case therapistNotFound
    }
    
    func saveAppointment(viewContext: NSManagedObjectContext, appointmentDate: Date, appointmentStartTime: Date, appointmentEndTime: Date, selectedTherapistObjectID: NSManagedObjectID, selectedServices: [Service]) -> Result<Void, Error> {
        let appointment = Appointment(context: viewContext)
        appointment.id = UUID()
        appointment.appointmentDate = appointmentDate
        appointment.appointmentTime = appointmentStartTime
        appointment.appointmentEndTime = appointmentEndTime
        appointment.status = "Pending"
        
        if let loggedInPatient = self.loggedInPatient {
            appointment.topatient = loggedInPatient
        } else {
            // Return an error if no patient is logged in
            return .failure(AppointmentError.patientNotFound)
        }

        if let therapist = viewContext.object(with: selectedTherapistObjectID) as? Therapist {
            appointment.totherapist = therapist
        }

        for service in selectedServices {
            appointment.addToToservice(service)
        }

        do {
            try viewContext.save()
            print("Appointment saved successfully.")
            return .success(())
        } catch {
            print("Could not save appointment. \(error)")
            return .failure(error)
        }
    }

     
    /*
     
     
     func fetchServicesFromCloudKit(completion: @escaping ([Service]?, Error?) -> Void) {
         let publicDB = CKContainer.default().publicCloudDatabase
         let query = CKQuery(recordType: "Service", predicate: NSPredicate(value: true))
         let operation = CKQueryOperation(query: query)
         var services: [Service] = []
         
         operation.recordMatchedBlock = { recordID, resultType in
             publicDB.fetch(withRecordID: recordID) { record, error in
                 if let error = error {
                     completion(nil, error)
                     return
                 }
                 guard let record = record else {
                     completion(nil, NSError(domain: "VoiceTherapyApp", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch service record."]))
                     return
                 }
                 let newService = Service(context: self.viewContext)
                 newService.id = UUID(uuidString: record.recordID.recordName)
                 newService.name = record["name"] as? String
                 newService.price = record["price"] as? Int16 ?? 0
                 newService.serviceDescription = record["serviceDescription"] as? String
                 newService.serviceDuration = record["serviceDuration"] as? Int16 ?? 0
                 services.append(newService)
             }
         }
         
         operation.queryResultBlock = { result in
             switch result {
             case .success(let cursor):
                 DispatchQueue.main.async {
                     do {
                         try self.viewContext.save()
                         completion(services, nil)
                     } catch {
                         completion(nil, error)
                     }
                 }
             case .failure(let error):
                 completion(nil, error)
             }
         }
         
         publicDB.add(operation)
     }

    
     func saveSampleServices(viewContext: NSManagedObjectContext) {
         let hasSavedSampleServicesKey = "hasSavedSampleServices"
         guard !UserDefaults.standard.bool(forKey: hasSavedSampleServicesKey) else { return }
         let service1 = Service(context: viewContext)
         service1.id = UUID()
         service1.name = "Hypnosis"
         service1.price = 200
         service1.serviceDescription = "A kool session involving hypno therapy."
         service1.serviceDuration = 60

         let service2 = Service(context: viewContext)
         service2.id = UUID()
         service2.name = "Therapy Session"
         service2.price = 150
         service2.serviceDescription = "One on One session."
         service2.serviceDuration = 90

         let service3 = Service(context: viewContext)
         service3.id = UUID()
         service3.name = "Online Therapy"
         service3.price = 50
         service3.serviceDescription = "Let's chat over facetime, zoom or gtalk. You pick."
         service3.serviceDuration = 120
         do {
             try viewContext.save()
             UserDefaults.standard.set(true, forKey: hasSavedSampleServicesKey)
         } catch {
             let nsError = error as NSError
             fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
         }
     }
 }
     
     
     func saveServicesToCloudKit() {
         let publicDB = CKContainer.default().publicCloudDatabase
         let services = [
             (name: "Hypnosis", price: 200, serviceDescription: "A kool session involving hypno therapy.", serviceDuration: 60),
             (name: "Therapy Session", price: 150, serviceDescription: "One on One session.", serviceDuration: 90),
             (name: "Online Therapy", price: 50, serviceDescription: "Let's chat over facetime, zoom or gtalk. You pick.", serviceDuration: 120)
         ]
         for service in services {
             let record = CKRecord(recordType: "Service")
             record["name"] = service.name as CKRecordValue
             record["price"] = service.price as CKRecordValue
             record["serviceDescription"] = service.serviceDescription as CKRecordValue
             record["serviceDuration"] = service.serviceDuration as CKRecordValue
             publicDB.save(record) { record, error in
                 if let error = error {
                     print("Error saving record: \(error.localizedDescription)")
                     return
                 }
                 if let record = record {
                     print("Saved record with ID: \(record.recordID.recordName)")
                 }
             }
         }
     }
     */
}
