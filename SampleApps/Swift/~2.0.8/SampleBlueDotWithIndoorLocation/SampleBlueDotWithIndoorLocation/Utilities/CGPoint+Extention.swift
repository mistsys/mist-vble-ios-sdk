//
//  CGPoint+Extention.swift
//  SampleBlueDotWithIndoorLocation
//
//  Created by Rajesh Vishwakarma on 16/03/23.
//

import Foundation

extension CGPoint {
    func scaleUpPoint(scale: Scale) -> CGPoint {
        return CGPoint(x: self.x * scale.x, y: self.y * scale.y)
    }
}
