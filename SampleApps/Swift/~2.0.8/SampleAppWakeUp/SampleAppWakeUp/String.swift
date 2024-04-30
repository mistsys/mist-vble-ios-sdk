//
//  String.swift
//  SampleAppWakeUp
//
//  Created by Rajesh Vishwakarma on 01/03/23.
//

import Foundation

extension String {
    
    var shortOrgUUIDString: String {
        let shortOrgId = String(self.dropLast(2))
        let orgUUIDString = String(format: "%@%@", shortOrgId, "0")
        return orgUUIDString
    }
}
