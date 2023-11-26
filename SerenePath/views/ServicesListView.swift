//
//  ServicesListView.swift
//  VoiceTherapy
//
//  Created by Kushal P on 3/27/23.
//
import SwiftUI
import CoreData
struct ServicesListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var viewModel: ViewModel
    let changeView: (ViewType) -> Void
    @State private var showDetail: Bool = false
    @State private var selectedService: Service?

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(hex: "#DDEDB6"), Color(hex: "#969DD3")]), startPoint: .top, endPoint: .bottom)
                            .edgesIgnoringSafeArea(.all)
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .center, spacing: 20) {
                            ForEach(viewModel.services, id: \.id) { service in
                                Button(action: {
                                    selectedService = service
                                    withAnimation {
                                        showDetail.toggle()
                                    }
                                }) {
                                    ServiceTile(service: service)
                                }
                            }
                        }
                        .padding()
                    }
                    Button("Back to main menu") {
                        changeView(.main)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(15.0)
                    .frame(width: 220, height: 60)
                    .padding()
                }
            .onAppear {
                viewModel.loadDefaultServices()
            }
            if showDetail {
                if let service = selectedService {
                    ServiceDetailView(service: service, showDetail: $showDetail)
                        .background(Color.white.opacity(0.95))
                        .cornerRadius(20)
                        .shadow(radius: 20)
                        .padding()
                        .transition(.scale)
                }
            }
            
        }
    }
}


struct ServiceTile: View {
    var service: Service

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(service.serviceImage ?? "placeholder")
                .resizable()
                .scaledToFit()
                .frame(width: 280, height: 280)
               // .foregroundColor(.white)
               // .padding(.top, 10)
            Text(service.name ?? "")
                .font(.headline)
                .foregroundColor(.white)
            Text("Duration: \(service.serviceDuration.description) mins")
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "#DAA520"), Color(hex: "#9ACD32")]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

struct ServicePreview {
    var id: UUID
    var name: String
    var price: Int16
    var serviceDescription: String
    var serviceDuration: Int16
    var serviceImage: String
}

struct ServicesListView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleServices: [ServicePreview] = [
            ServicePreview(id: UUID(), name: "Online Therapy", price: 100, serviceDescription: "Let's chat over facetime, zoom or gtalk. You pick.", serviceDuration: 60, serviceImage: "mindfultherapy"),
            ServicePreview(id: UUID(), name: "Therapy Session", price: 150, serviceDescription: "Service 2 description", serviceDuration: 90, serviceImage: "mindfultherapy")
        ]
        
        let viewModel = ViewModel()
        let context = PersistenceController.shared.container.viewContext
        viewModel.services = sampleServices.map { preview in
            Service(from: preview, context: context)
        }

        return ServicesListView(changeView: { _ in }).environmentObject(ViewModel())
        
    }
}
