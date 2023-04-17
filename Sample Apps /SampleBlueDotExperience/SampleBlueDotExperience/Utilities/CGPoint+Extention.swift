//
//  CGPoint+Extention.swift
//  SampleBlueDotExperience
//
//  Created by Rajesh Vishwakarma on 08/02/23.
//

import Foundation

extension CGPoint {
    func scaleUpPoint(scale: Scale) -> CGPoint {
        return CGPoint(x: self.x * scale.x, y: self.y * scale.y)
    }
}
