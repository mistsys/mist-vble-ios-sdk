//
//  ViewController.swift
//  SampleBlueDotExperience
//
//  Created by Rajesh Vishwakarma on 27/01/23.
//

import UIKit
import MistSDK

class ViewController: UIViewController {
    
    let blueDot: UIView = {
        let dotView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 10))
        dotView.translatesAutoresizingMaskIntoConstraints = false
        dotView.layer.cornerRadius = 5
        dotView.backgroundColor = UIColor(red: 0.072, green: 0.593, blue: 0.997, alpha: 1.0)
        return dotView
    }()
    
    let debugInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    var viewModel: ViewModel?
    var scale: Scale?
    var isMapLoaded = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.viewModel = ViewModel(delegate: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        viewModel?.start()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        HUDProgress.shared.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel?.stop()
    }
    
    private func setupMapView(with image: UIImage) {
        
        let floorMapView = UIView(frame: self.view.bounds)
        floorMapView.translatesAutoresizingMaskIntoConstraints = false
        floorMapView.backgroundColor = .white
        view.addSubview(floorMapView)
        
        let floorImageView = UIImageView(image: image)
        floorImageView.contentMode = .scaleAspectFit
        floorImageView.translatesAutoresizingMaskIntoConstraints = false
        floorMapView.addSubview(floorImageView)
        
        floorMapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        floorMapView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        floorMapView.layoutIfNeeded()
        
        let floorViewRatio = view.bounds.size.width / view.bounds.size.height
        let imageRatio = image.size.width/image.size.height
        
        if imageRatio >= floorViewRatio {
            floorMapView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 10).isActive = true
            floorMapView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: image.size.height/image.size.width, constant: 0).isActive = true
        } else {
            floorMapView.widthAnchor.constraint(equalToConstant: view.bounds.height - 10).isActive = true
            floorMapView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: image.size.width/image.size.height, constant: 0).isActive = true
        }
                
        floorMapView.layoutIfNeeded()
    
        floorMapView.addSubview(blueDot)
        floorMapView.bringSubviewToFront(blueDot)
        view.addSubview(debugInfoLabel)
        
        NSLayoutConstraint.activate([
            floorImageView.topAnchor.constraint(equalTo: floorMapView.topAnchor),
            floorImageView.leadingAnchor.constraint(equalTo: floorMapView.leadingAnchor),
            floorImageView.trailingAnchor.constraint(equalTo: floorMapView.trailingAnchor),
            floorImageView.bottomAnchor.constraint(equalTo: floorMapView.bottomAnchor),

            blueDot.widthAnchor.constraint(equalToConstant: 10.0),
            blueDot.heightAnchor.constraint(equalToConstant: 10.0),
            
            debugInfoLabel.topAnchor.constraint(equalTo: floorMapView.bottomAnchor, constant: 20),
            debugInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            debugInfoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            debugInfoLabel.heightAnchor.constraint(equalToConstant: 50.0),
            
        ])
        
                
        view.layoutIfNeeded()
        
        // Calculate the Scale Factor
        let scaleX = floorMapView.bounds.width / image.size.width
        let scaleY = floorMapView.bounds.height / image.size.height
        
        scale = Scale(x: scaleX, y: scaleY)
    }
}

// MARK: - ViewModelDelegate
extension ViewController: ViewModelDelegate {
    
    func loadMap(with image: UIImage) {
        HUDProgress.shared.stop()
        setupMapView(with: image)
        isMapLoaded = true
    }
    
    func updateBluedotLocation(with point: CGPoint) {
        guard isMapLoaded, let scale = scale else { return }
        let relativeLocation = point.scaleUpPoint(scale: scale)
        self.blueDot.center = relativeLocation
        debugInfoLabel.text = "{ Remote x=\(point.x), y=\(point.y)}\n{ Local x=\(relativeLocation.x.rounded()) y=\(relativeLocation.y.rounded())}"
    }
    
    func failedToUpdateMap(with error: String?) {
        guard let error = error else { return }
        debugPrint("Error: unable to update map with Error: \(error)")
    }
}
