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
    
    
    
    init() {
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
    
    func authenticateWithBiometric()  {
        
        // NSFaceIDUsageDescription Key IN info.plist
        let biometricPublisher = Future<Bool, Never> {[unowned self] promise in
            let myLocalizedReasonString = ""
            var authError: NSError?
            if self.canAuthenticate(error: &authError) {
                self.laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, evaluateError in
                    return  promise(.success(success))
                }
            } else {
                print(authError ?? "")
            }
        }.eraseToAnyPublisher()
        
        
        //        biometricPublisher
        //            .receive(on: DispatchQueue.main)
        //            .assign(to: \.isLoggedIn, on: self)
        //            .store(in: &self.cancellableSet)
        
        
    }
    
    func canAuthenticate(error: NSErrorPointer) -> Bool {
        self.laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: error)
    }
    
    
}
