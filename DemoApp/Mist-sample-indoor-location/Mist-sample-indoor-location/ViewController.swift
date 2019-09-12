//
//  ViewController.swift
//  DemoApp
//
//  Created by Ajay Gantayet on 6/21/18.
//

import MistSDK
import UIKit

class ViewController: UIViewController, MSTCentralManagerDelegate, MSTCentralManagerMapDataSource {
    
    let kSettings = "com.mist.mistsdk_credentials"
    
    // client secret for test
    var sdkSecret: String?
    var localSettings = [AnyHashable: Any]()

    @IBOutlet var progressView: UIActivityIndicatorView!
    @IBOutlet var mapImageView: UIImageView!

    var marker: UIView!
    var currentMap: MSTMap?
    var backdropView: UIView?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    var scaleX: Float?
    var scaleY: Float?
    var ppm: Double?
    var virtualBeacons: [AnyHashable: Any]?
    var manager: MSTCentralManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        backdropView = UIView()
        
        // Enroll to the org using the sdk secret
        if let secret = sdkSecret {
            hardCodeReceivedQr(secret: secret)
        }
        mapImageView.contentMode = .scaleAspectFit
    }

    func map(forMapId _: String) -> UIImage? {
        return nil
    }

    @IBAction func dissmissVC(_: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MSTCentralManagerDelegates - delegates
    
    func mistManager(_: MSTCentralManager!, didConnect isConnected: Bool) {
        print("Connection State: \(isConnected)")
    }

    func mistManager(_: MSTCentralManager!, didUpdate map: MSTMap!, at _: Date!) {
        DispatchQueue.main.async {
            
            guard let newMap = map, let newMapImage = newMap.mapImage, newMap.mapType == .IMAGE else {
                return
            }
            
            self.ppm = newMap.ppm
            self.scaleX = Float(self.mapImageView.bounds.size.width / newMapImage.size.width)
            self.scaleY = Float(self.mapImageView.bounds.size.height / newMapImage.size.height)

            if let previousMap = self.currentMap {
                if previousMap.mapId != newMap.mapId {
                    self.addIndoorMapView(url: newMap.mapURL)
                }
            } else {
                self.currentMap = newMap
                self.addIndoorMapView(url: newMap.mapURL)
            }
        }
    }

    func mistManager(_: MSTCentralManager!, didUpdateRelativeLocation relativeLocation: MSTPoint!, inMaps _: [Any]!, at _: Date!) {
        DispatchQueue.main.async {
            let point: MSTPoint = relativeLocation
            self.updatePoint(point: point)
        }
    }

    func addIndoorMapView(url: String) {
        DispatchQueue.main.async {
            self.progressView.isHidden = true
        }
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            guard let data = try? Data.init(contentsOf: URL(string: url)!) else { return }
            DispatchQueue.main.async {
                let image = UIImage.init(data: data)
                self.mapImageView.image = image;
            }
        }
    }
    
    func updatePoint(point: MSTPoint) {
        guard let _ = ppm, let _ = scaleX, let _ = scaleY else {
            return
        }

        let leEstCGPoint = scaleUp(convertMeters(toPixels: point.convertToCGPoint()))

        if let previousMarker = marker {
            previousMarker.removeFromSuperview()
        }

        marker = UIView(frame: CGRect(x: leEstCGPoint.x, y: leEstCGPoint.y, width: 10, height: 10))
        marker.layer.cornerRadius = 5
        marker.backgroundColor = UIColorFromHex(rgbValue: 0x0087CC)
        view.addSubview(marker)
    }

    // Utilities
    func convertMeters(toPixels point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x * CGFloat(ppm!), y: point.y * CGFloat(ppm!))
    }

    func scaleUp(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: CGFloat(Float(point.x) * scaleX!), y: CGFloat(Float(point.y) * scaleY!))
    }

    func shouldDownloadMap(_: MSTCentralManager) -> MSTCentralManagerMapDataSourceOption {
        return MSTCentralManagerMapDataSourceOption.download
    }

    func hardCodeReceivedQr(secret: String) {
        MSTOrgCredentialsManager.enrollDevice(withToken: secret, onComplete: { response, error in
            
            guard error == nil, response != nil, let env = secret.first else {
                print("Error: Cannot enroll devices to organization. \n\(error)")
                return
            }
            
            guard let response = response,
                let name = response["name"] as? String,
                let org_id = response["org_id"] as? String,
                let secret = response["secret"] as? String else {
                    print("Error: Cannot retrieve org or secret from org enrollment")
                return
            }
            
            DispatchQueue.main.async {
                let dict: [String: String] = ["name": name,
                            "tokenID": org_id,
                            "tokenSecret": secret,
                            "tokenEnvType": String.init(env)]
                self.manager = MSTCentralManager(orgID: org_id, andOrgSecret: secret)
                self.manager?.delegate = self
                self.manager?.setAppState(UIApplication.shared.applicationState)
                self.manager?.startLocationUpdates()
                self.updateSettings(dict)
            }
        })
    }

    func purgeSettings() {
        localSettings = [AnyHashable: Any]()
        UserDefaults.standard.set(localSettings, forKey: kSettings)
        UserDefaults.standard.synchronize()
    }

    func updateSettings(_ settings: [AnyHashable: Any]?) {
        UserDefaults.standard.set(settings, forKey: kSettings)
        UserDefaults.standard.synchronize()
        localSettings = settings!
    }

    func UIColorFromHex(rgbValue: UInt32, alpha: Double = 1.0) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8) / 256.0
        let blue = CGFloat(rgbValue & 0xFF) / 256.0

        return UIColor(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
    }
}
