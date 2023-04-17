//
//  String.swift
//  SampleBlueDotWithIndoorLocation
//
//  Created by Rajesh Vishwakarma on 16/03/23.
//

import Foundation

extension String {
    
    var shortOrgUUIDString: String {
        let shortOrgId = String(self.dropLast(2))
        let orgUUIDString = String(format: "%@%@", shortOrgId, "0")
        return orgUUIDString
    }
}
