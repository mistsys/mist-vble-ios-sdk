//
//  HUDProgress.swift
//  SampleBlueDotWithIndoorLocation
//
//  Created by Rajesh Vishwakarma on 16/03/23.
//

import UIKit

final class HUDProgress {
    static let shared = HUDProgress()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .black
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private init() {
        guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return }
        window.addSubview(spinner)
        spinner.center = CGPoint(x: window.bounds.width/2, y: window.bounds.height/2)
    }
    
    func start() {
        spinner.startAnimating()
    }
    
    func stop() {
        spinner.stopAnimating()
    }
}
