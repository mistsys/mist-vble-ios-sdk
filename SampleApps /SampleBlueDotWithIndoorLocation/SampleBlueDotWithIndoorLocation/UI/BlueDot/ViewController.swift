//
//  ViewController.swift
//  SampleBlueDotWithIndoorLocation
//
//  Created by Rajesh Vishwakarma on 27/01/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private var wakeUpSwitch: UISwitch!
    @IBOutlet private var mistSdkSwitch: UISwitch!
    @IBOutlet private var mapContainer: UIView!
    @IBOutlet private var statusLabel: UILabel!
    
    private let blueDot: UIView = {
        let dotView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 10))
        dotView.translatesAutoresizingMaskIntoConstraints = false
        dotView.layer.cornerRadius = 5
        dotView.backgroundColor = UIColor(red: 0.072, green: 0.593, blue: 0.997, alpha: 1.0)
        return dotView
    }()
    
    var viewModel: ViewModelDelegate?
    
    private var scale: Scale?
    private var isMapLoaded = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        // Assemble Component and Inject Dependencies
        configurator()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        statusLabel.isHidden = true
        
        wakeUpSwitch.isOn = viewModel?.isMistServiceRuning ?? false
        mistSdkSwitch.isOn = viewModel?.isMistServiceRuning ?? false
    }
    
    @IBAction func enableMistSDKService(_ sender: UISwitch) {
        
        if sender.isOn {
            HUDProgress.shared.start()
            viewModel?.startMistService()
        } else {
            viewModel?.stopMistService()
        }
    }
    
    @IBAction func enableAppWakeUpService(_ sender: UISwitch) {
        
        if sender.isOn {
            viewModel?.startWakeUp()
        } else {
            viewModel?.stopWakeUp()
        }
    }
    
    func updateStatus(_ loc: CGPoint) {
        let ppm = viewModel?.mapPPMValue ?? 1
        let clientLocation = CGPoint(x: loc.x / ppm, y: loc.y / ppm)
        statusLabel.text = String(format: "BlueDot Location on Map X= %.1f, Y= %.1f", clientLocation.x, clientLocation.y)
    }
}

extension ViewController {
    
    private func configurator() {
        #if !targetEnvironment(simulator)
        let mistService = RealMistService(token: Mist.SDK.token)
        let wakeUpService = RealWakeupService()
        let viewModel = ViewModel(mistService: mistService, wakeUpService: wakeUpService)
        mistService.delegate = viewModel
        wakeUpService.delegate = viewModel
        viewModel.delegate = self
        self.viewModel = viewModel
        #endif
    }
    
    private func setupMapView(with image: UIImage) {
        
        let floorMapView = UIView(frame: self.view.bounds)
        floorMapView.translatesAutoresizingMaskIntoConstraints = false
        floorMapView.backgroundColor = .white
        mapContainer.addSubview(floorMapView)
        
        let floorImageView = UIImageView(image: image)
        floorImageView.contentMode = .scaleAspectFit
        floorImageView.translatesAutoresizingMaskIntoConstraints = false
        floorMapView.addSubview(floorImageView)
        
        floorMapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        floorMapView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        floorMapView.layoutIfNeeded()
        
        let floorViewRatio = mapContainer.bounds.size.width / mapContainer.bounds.size.height
        let imageRatio = image.size.width/image.size.height
        
        if imageRatio >= floorViewRatio {
            floorMapView.widthAnchor.constraint(equalTo: mapContainer.widthAnchor, constant: 0).isActive = true
            floorMapView.heightAnchor.constraint(equalTo: mapContainer.widthAnchor, multiplier: image.size.height/image.size.width, constant: 0).isActive = true
        } else {
            floorMapView.widthAnchor.constraint(equalToConstant: mapContainer.bounds.height).isActive = true
            floorMapView.heightAnchor.constraint(equalTo: mapContainer.widthAnchor, multiplier: image.size.width/image.size.height, constant: 0).isActive = true
        }
        
        floorMapView.layoutIfNeeded()
        
        floorMapView.addSubview(blueDot)
        floorMapView.bringSubviewToFront(blueDot)
        
        NSLayoutConstraint.activate([
            floorImageView.topAnchor.constraint(equalTo: floorMapView.topAnchor),
            floorImageView.leadingAnchor.constraint(equalTo: floorMapView.leadingAnchor),
            floorImageView.trailingAnchor.constraint(equalTo: floorMapView.trailingAnchor),
            floorImageView.bottomAnchor.constraint(equalTo: floorMapView.bottomAnchor),
            
            blueDot.widthAnchor.constraint(equalToConstant: 10.0),
            blueDot.heightAnchor.constraint(equalToConstant: 10.0)
        ])
        
        mapContainer.layoutIfNeeded()
        
        // Calculate the Scale Factor
        let scaleX = floorMapView.bounds.width / image.size.width
        let scaleY = floorMapView.bounds.height / image.size.height
        
        scale = Scale(x: scaleX, y: scaleY)
    }
}


// MARK: - ViewDelegate

extension ViewController: ViewDelegate {
    
    func didMistServiceStarted() {
        HUDProgress.shared.start()
        if let mistSdkSwitch = mistSdkSwitch {
            mistSdkSwitch.isOn = true
        }
    }
    
    func didLoadMistMap(with image: UIImage) {
        HUDProgress.shared.stop()
        setupMapView(with: image)
        isMapLoaded = true
        statusLabel.isHidden = false
    }
    
    func didUpdateMistLocation(with point: CGPoint) {
        guard isMapLoaded, let scale = scale else { return }
        let relativeLocation = point.scaleUpPoint(scale: scale)
        self.blueDot.center = relativeLocation
        updateStatus(point)
    }
}

