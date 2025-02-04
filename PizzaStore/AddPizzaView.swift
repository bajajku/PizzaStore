import SwiftUI

struct AddPizzaView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = PizzaStoreViewModel()
    
    @State private var name: String = ""
    @State private var image: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Pizza Details")) {
                    TextField("Pizza Name", text: $name)
                    TextField("Image URL", text: $image)
                }
                
                Section {
                    Button("Add Pizza") {
                        guard !name.isEmpty && !image.isEmpty else {
                            alertMessage = "Please fill in all fields"
                            showingAlert = true
                            return
                        }
                        
                        viewModel.createPizza(name: name, image: image) { success in
                            if success {
                                dismiss()
                            } else {
                                alertMessage = "Failed to create pizza"
                                showingAlert = true
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add New Pizza")
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
            .alert("Error", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
} 