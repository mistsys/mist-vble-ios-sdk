//
//  ViewModel.swift
//  SampleIndoorLocationReporting
//
//  Created by Rajesh Vishwakarma on 27/01/23.
//

import Foundation

class ViewModel {
    private var service: MistService?
    
    init() {
        #if !targetEnvironment(simulator)
        self.service = RealMistService(token: MistSDK.token)
        #endif
    }
    
    func start() {
        guard !MistSDK.token.isEmpty else {
            debugPrint("Kindly copy the token")
            return
        }
        service?.start()
    }
    
    func stop() {
        service?.stop()
    }
}
