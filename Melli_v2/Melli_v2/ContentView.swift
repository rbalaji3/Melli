import SwiftUI
import AuthenticationServices

struct ContentView: View {
    @State private var signedInUserID: String?

    var body: some View {
        NavigationView {
            VStack {
                if let signedInUserID = signedInUserID {
                    NavigationLink(
                        destination: SearchView(userId: signedInUserID),
                        label: {
                            Text("Search")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                    )
                } else {
                    SignInWithAppleButton(
                        onRequest: { request in
                            // Handle authorization request
                        },
                        onCompletion: { result in
                            switch result {
                            case .success(let authorization):
                                // Extract user identifier
                                if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                                    let userIdentifier = appleIDCredential.user
                                    signedInUserID = userIdentifier
                                } else {
                                    // Handle unexpected credential type
                                    print("Unexpected credential type.")
                                }
                            case .failure(let error):
                                // Handle sign-in failure
                                print("Sign in with Apple failed: \(error)")
                            }
                        }
                    )
                    .frame(width: 200, height: 44)
                }
            }
            .navigationTitle("Feed")
            .navigationBarHidden(false)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
