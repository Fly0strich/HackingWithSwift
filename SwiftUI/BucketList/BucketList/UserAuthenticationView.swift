//
//  UserAuthenticationView.swift
//  BucketList
//
//  Created by Shae Willes on 7/12/21.
//

import SwiftUI
import LocalAuthentication

struct UserAuthenticationView: View {
    @Binding var isUnlocked: Bool
    
    @State private var showingAuthenticationError = false
    @State private var authenticationErrorTitle = ""
    @State private var authenticationErrorMessage = ""
    
    var body: some View {
        Button("Unlock Places") {
            self.authenticate()
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .clipShape(Capsule())
        .alert(isPresented: $showingAuthenticationError) {
            Alert(title: Text(authenticationErrorTitle), message: Text(authenticationErrorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to make sure it's you."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        isUnlocked = true
                    } else {
                        authenticationErrorTitle = "Authentication Failed"
                        authenticationErrorMessage = authenticationError!.localizedDescription
                        showingAuthenticationError = true
                    }
                }
            }
        } else {
            authenticationErrorTitle = "Authentication Failed"
            authenticationErrorMessage = "Your device does not support biometric authentication."
            showingAuthenticationError = true
        }
    }
}

struct UserAuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        UserAuthenticationView(isUnlocked: .constant(false))
    }
}
