//
//  ViewModel.swift
//  SampleBlueDotExperience
//
//  Created by Rajesh Vishwakarma on 27/01/23.
//

import Foundation
import UIKit

protocol ViewDelegate: AnyObject {
    func loadMap(with image: UIImage)
    func didUpdateMistLocation(with point: CGPoint)
    func failed(with error: String?)
}

protocol ViewModelMistServiceDelegate: AnyObject {
    var  isMistServiceRuning: Bool { get }
    var  mapPPMValue: Double { get }
    func startMistService()
    func stopMistService()
}

typealias ViewModelDelegate = ViewModelMistServiceDelegate

class ViewModel {
    weak var delegate: ViewDelegate?
    
    private let mistService: MistService?
    private let downloader: Downloadable
        
    init(mistService: MistService, downloader: Downloadable = MapDownloader()) {
        self.mistService = mistService
        self.downloader = downloader
    }
}

extension ViewModel: ViewModelMistServiceDelegate {
    var  isMistServiceRuning: Bool {
        mistService?.isStarted ?? false
    }
    
    var mapPPMValue: Double {
        mistService?.mapPpmValue ?? 0
    }
    
    func startMistService() {
        guard !MistSDK.token.isEmpty else {
            debugPrint("? Token is missing")
            return
        }
        mistService?.start()
    }
    
    func stopMistService() {
        mistService?.stop()
    }
}

// MARK: - MistServiceDelegate

extension ViewModel: MistServiceDelegate {
    
    func didUpdateMap(_ map: URL) {
        // Download Map Image and Load the Map
        downloader.download(url: map) { [weak self] (image, error) in
            guard let image else { return }
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.loadMap(with: image)
            }
        }
    }
    
    func didUpdateLocation(_ location: CGPoint) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.didUpdateMistLocation(with: location)
        }
    }
    
    func didFailed(with error: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.failed(with: error)
        }
    }
}
