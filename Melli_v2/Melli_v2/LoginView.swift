import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @State private var signedInUserID: String?
    
    var body: some View {
        ZStack {
            VStack {
                Text("Melli")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 20)
                
                Spacer()
                
                if let signedInUserID = signedInUserID {
                    BottomBarv1(userId: signedInUserID)
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
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(false)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
