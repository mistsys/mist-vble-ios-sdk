//
//  ViewModel.swift
//  SampleBlueDotExperience
//
//  Created by Rajesh Vishwakarma on 27/01/23.
//

import Foundation
import UIKit

protocol ViewModelDelegate: AnyObject {
    func loadMap(with image: UIImage)
    func updateBluedotLocation(with point: CGPoint)
    func failedToUpdateMap(with error: String?)
}

struct Scale {
    var x: Double = 0
    var y: Double = 0
}

class ViewModel {
    weak var delegate: ViewModelDelegate?
    
    let downloader: Downloadable
    var service: MistService?
    
    var mapImage: UIImage?
    
    init(delegate: ViewModelDelegate, downloader: Downloadable = MapDownloader()) {
        self.delegate = delegate
        self.downloader = downloader
        
        #if !targetEnvironment(simulator)
        self.service = RealMistService(token: MistSDK.token, delegate: self)
        #endif
    }
    
    func start() {
        guard !MistSDK.token.isEmpty else {
            debugPrint("Token is missing !!!")
            return
        }
        service?.start()
    }
    
    func stop() {
        service?.stop()
    }
}

// MARK: - MistServiceDelegate

extension ViewModel: MistServiceDelegate {
    
    func didUpdateMap(_ map: URL) {
        // Download Map Image and Load the Map
        downloader.download(url: map) { image, error in
            if let image = image {
                self.mapImage = image
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.loadMap(with: image)
                }
            }
        }
    }
    
    func didUpdateLocation(_ location: CGPoint) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.updateBluedotLocation(with: location)
        }
    }
    
    func didFailedToUpdateMap(with error: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.failedToUpdateMap(with: error)
        }
    }
}
