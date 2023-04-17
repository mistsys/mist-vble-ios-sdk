//
//  Constants.swift
//  SampleAppWakeUp
//
//  Created by Rajesh Vishwakarma on 27/02/23.
//

import Foundation

struct Mist {
    
    struct SDK {
        // Your Mist SDK Token
        static let token = "<sdk token>"
        // Your Mist Organization Id
        static let orgId = "<org id>"
    }
   
    struct WakeUp {
        static let monitoringMessage = "The app is monitoring beacons. You can close the app now."
        static let notMonitoringMessage = "The app is not monitoring beacons."
    }
}
