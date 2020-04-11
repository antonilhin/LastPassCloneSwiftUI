//
//  AuthenticationManager.swift
//  LastPassCloneSwiftUI
//
//  Created by Antoni on 10/04/20.
//  Copyright © 2020 Antonilhin. All rights reserved.
//

import SwiftUI
import Combine
import LocalAuthentication
import KeychainSwift
import CryptoKit

class AuthenticationManager: ObservableObject {
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    @Published var email = ""
    @Published var password = ""
    @Published var confirmedPassword = ""
    
    @Published var canLogin = false
    @Published var canSignup = false
    
    
    @Published var emailValidation = FormValidation()
    @Published var passwordValidation = FormValidation()
    @Published var confirmedPasswordValidation = FormValidation()
    @Published var similarityValidation = FormValidation()
    
    private var userDefaults = UserDefaults.standard
    private var laContext = LAContext()
    
    @Published var isLoggedIn = false
    @Published var userAccount = User()
    private var keychain = KeychainSwift()
    
    @Published var biometryType = LABiometryType.none
    
    struct Config {
        static let recommendedLength = 6
        static let specialCharacters = "!@#$%^&*()?/|\\:;"
        static let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        static let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8,}$")
    }
    
    private var emailPublisher: AnyPublisher<FormValidation, Never> {
        self.$email.debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { email in
                
                if email.isEmpty{
                    return FormValidation(success: false, message: "")
                }
                
                if !Config.emailPredicate.evaluate(with: email){
                    return FormValidation(success: false, message: "Invalid email address")
                }
                
                return FormValidation(success: true, message: "")
        }.eraseToAnyPublisher()
    }
    
    private var passwordPublisher: AnyPublisher<FormValidation, Never> {
        self.$password.debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                
                if password.isEmpty{
                    return FormValidation(success: false, message: "")
                }
                if password.count < Config.recommendedLength{
                    return FormValidation(success: false, message: "The password length must be greater than \(Config.recommendedLength) ")
                }
                
                
                if !Config.passwordPredicate.evaluate(with: password){
                    return FormValidation(success: false, message: "The password is must contain numbers, uppercase and special characters")
                }
                
                return FormValidation(success: true, message: "")
        }.eraseToAnyPublisher()
    }
    
    private var confirmPasswordPublisher: AnyPublisher<FormValidation, Never> {
        self.$confirmedPassword.debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            
            .map { password in
                
                if password.isEmpty{
                    return FormValidation(success: false, message: "")
                }
                
                if password.count < Config.recommendedLength{
                    return FormValidation(success: false, message: "The password length must be greater than \(Config.recommendedLength) ")
                }
                
                
                
                if !Config.passwordPredicate.evaluate(with: password){
                    return FormValidation(success: false, message: "The password is must contain numbers, uppercase and special characters")
                }
                
                
                return FormValidation(success: true, message: "")
        }.eraseToAnyPublisher()
    }
    
    private var similarityPublisher: AnyPublisher<FormValidation, Never> {
        Publishers.CombineLatest($password, $confirmedPassword)
            .map { password, confirmedPassword in
                
                if password.isEmpty || confirmedPassword.isEmpty{
                    return FormValidation(success: false, message: "")
                }
                
                if password != confirmedPassword{
                    return FormValidation(success: false, message: "Passwords do not match!")
                }
                return FormValidation(success: true, message: "")
        }.eraseToAnyPublisher()
    }
    
    private lazy var biometryPublisher: Future<Bool, Never> = {
        Future<Bool, Never> {[unowned self] promise in
            let myLocalizedReasonString = "Replace with your description explaining why you want to use biometrics"
            var authError: NSError?
            self.laContext.localizedFallbackTitle = "Please use your Passcode"
            if self.canAuthenticate(error: &authError) {
                self.laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, evaluateError in
                    return  promise(.success(success))
                }
            } else {
                print(authError ?? "")
                return promise(.success(false))
            }
        }
    }()
    
    init() {
        
        getBiometryType()
        emailPublisher
            .assign(to: \.emailValidation, on: self)
            .store(in: &self.cancellableSet)
        
        passwordPublisher
            .assign(to: \.passwordValidation, on: self)
            .store(in: &self.cancellableSet)
        
        confirmPasswordPublisher
            .assign(to: \.confirmedPasswordValidation, on: self)
            .store(in: &self.cancellableSet)
        
        similarityPublisher
            .assign(to: \.similarityValidation, on: self)
            .store(in: &self.cancellableSet)
        
        // Login
        Publishers.CombineLatest(emailPublisher, passwordPublisher)
            .map { emailValidation, passwordValidation  in
                emailValidation.success && passwordValidation.success
        }.assign(to: \.canLogin, on: self)
            .store(in: &self.cancellableSet)
        
        // Sign Up
        Publishers.CombineLatest4(emailPublisher, passwordPublisher, confirmPasswordPublisher, similarityPublisher)
            .map { emailValidation, passwordValidation, confirmedPasswordValidation, similarityValidation  in
                emailValidation.success && passwordValidation.success && confirmedPasswordValidation.success && similarityValidation.success
        }.assign(to: \.canSignup, on: self)
            .store(in: &self.cancellableSet)
        
    }
    
    
    func hasAccount() -> Bool {
        guard let _ = keychain.get(AuthKeys.email)  else { return false }
        return true
    }
    
    func createAccount()  {
        guard !hasAccount() else { return }
        let hashedPassword = hashPassword(password)
        let emailResult = keychain.set(email.lowercased(), forKey: AuthKeys.email, withAccess: .accessibleWhenPasscodeSetThisDeviceOnly)
        let passwordResult = keychain.set(hashedPassword, forKey: AuthKeys.password, withAccess: .accessibleWhenPasscodeSetThisDeviceOnly)
        if emailResult && passwordResult {
            login()
        }
    }
    
    func login() {
        userDefaults.set(true, forKey: AuthKeys.isLoggedIn)
        self.isLoggedIn = true
    }
    
    private func hashPassword(_ password: String) -> String {
        var salt = ""
        
        if let savedSalt = keychain.get(AuthKeys.salt) {
            salt = savedSalt
        } else {
            let key = SymmetricKey(size: .bits256)
            salt = key.withUnsafeBytes({ Data(Array($0)).base64EncodedString() })
            keychain.set(salt, forKey: AuthKeys.salt)
        }
        
        guard let data = "\(password)\(salt)".data(using: .utf8) else { return "" }
        let digest = SHA256.hash(data: data)
        return digest.map{String(format: "%02hhx", $0)}.joined()
    }
    
    func authenticate() -> Bool{
        if let savedEmail = keychain.get(AuthKeys.email),
            let savedPassword = keychain.get(AuthKeys.password),
            let salt = keychain.get(AuthKeys.salt){
            let hashedPassword = hashPassword("\(password)\(salt)")
            if savedEmail == email.lowercased() && hashedPassword == savedPassword{
                login()
                return true
            }
        }
        return false
    }
    
    func logout() {
        userDefaults.set(false, forKey: AuthKeys.isLoggedIn)
        self.isLoggedIn = false
    }
    
    func deleteAccount()  {
        keychain.delete(AuthKeys.email)
        keychain.delete(AuthKeys.password)
        keychain.delete(AuthKeys.salt)
        logout()
    }
    
    func canAuthenticate(error: NSErrorPointer) -> Bool {
        self.laContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: error)
    }
    
    func authenticateWithBiometric()  {
        guard hasAccount() else { return }
        biometryPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoggedIn, on: self)
            .store(in: &self.cancellableSet)
        
    }
    
    func getBiometryType() {
        var authError: NSError?
        if canAuthenticate(error: &authError){
            self.biometryType = laContext.biometryType
        }
    }
    
}
