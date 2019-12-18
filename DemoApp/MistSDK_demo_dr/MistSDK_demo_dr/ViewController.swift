//
//  ViewController.swift
//  MistSDK_demo_dr
//
//  Created by Pooja Gulabchand Mishra on 11/22/19.
//  Copyright © 2019 Pooja Gulabchand Mishra. All rights reserved.
//

import UIKit
import MistSDK
import CoreMotion

class ViewController: UIViewController, MSTCentralManagerDelegate,MSTCentralManagerMapDataSource, CLLocationManagerDelegate {
    
    @IBOutlet var progressView: UIActivityIndicatorView!
    @IBOutlet var mapImageView: UIImageView!
    let kSetting = "com.mist.mistCredentials"
    var sdkSecret : String?
    var localSettings = [AnyHashable: Any]()
    var marker: UIView?
    var currentMap: MSTMap?
    var currBackdrop: UIView?
    
    var locationManager : CLLocationManager?
    var scaleX:Float?
    var scaleY:Float?
    var ppm:Double?     // Pixel per meter
    
    
    var point: MSTPoint?
    
    
    var virtaulBeacons :[AnyHashable: Any]?
    var manager: MSTCentralManager?
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currBackdrop = UIView()
        
        //enroll the sdk secret
        if let sdkSecret = sdkSecret{
            enrollDeviceWithSecret(secret: sdkSecret)
            self.view.backgroundColor = UIColor.lightGray
        }
        mapImageView.contentMode = .scaleAspectFit
        initialize()
    }
    
    //MARK: Initialization
    
    func initialize(){
        
        guard let sdkSecret = sdkSecret else {return}
        getLocationManager()
        //The above set of UUIDs have to be used as is
        locationManager?.delegate = self
        locationManager?.pausesLocationUpdatesAutomatically = false
        var beaconRegion: CLBeaconRegion? = nil
        if let anID = UUID(uuidString: sdkSecret) {
            beaconRegion = CLBeaconRegion(proximityUUID: anID, identifier: sdkSecret)
        }
        
        //Stop monitoring for region if we are already monitoring it
        if let aRegion = beaconRegion {
            locationManager?.stopMonitoring(for: aRegion)
        }
        locationManager?.stopUpdatingLocation()
        //Start monitoring for region
        if let aRegion = beaconRegion {
            locationManager?.startMonitoring(for: aRegion)
        }
        beaconRegion?.notifyOnEntry = true
        beaconRegion?.notifyOnExit = true
        beaconRegion?.notifyEntryStateOnDisplay = true
        locationManager?.startUpdatingLocation()
        
    }
    
    
    
    //MARK: location update
    
    func getLocationManager() {
        if locationManager == nil {
            locationManager = CLLocationManager()
            if (locationManager?.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization)))! {
                locationManager?.requestAlwaysAuthorization()
            }
            if (locationManager?.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)))! {
                locationManager?.requestWhenInUseAuthorization()
            }
        }
    }
    
    
    //MARK: - MistSDK Callbacks
    
    func enrollDeviceWithSecret(secret:String)
    {
        MSTOrgCredentialsManager.enrollDevice(withToken: secret, onComplete: { response , error in
            guard error == nil , response != nil , let env = secret.first else
            {
                print("Error: unable to enroll Org.\n\(String(describing:error))")
                return
            }
            
            guard let response = response,
                let name = response["name"] as? String,
                let orgId = response["org_id"] as? String,
                let secretToken = response["secret"] as? String else{
                    print("Error: unable to fetch orgId and secretToken")
                    return
            }
            
            
            DispatchQueue.main.async {
                let dict: [String: String] = ["name" : name,
                                              "secretToken" : secretToken,
                                              "orgId" : orgId,
                                              "tokenEnvType" : String.init(env)]
                
                
                self.manager = MSTCentralManager(orgID: orgId, andOrgSecret: secretToken)
                self.manager?.delegate = self;
                self.manager?.startLocationUpdates()
                self.manager?.wakeUpAppSetting(true)
                //  self.manager?.setSentTimeInBackgroundInMins(0.5, restTimeInBackgroundInMins:5)
                self.updateSettings(dict)
            }
            
        })
    }
    
    func mistManager(_ manager: MSTCentralManager!, didConnect isConnected: Bool) {
        print("didConnect callback response is: \(isConnected)")
    }
    
    
    func mistManager(_ manager: MSTCentralManager!, didUpdateDRMap map: MSTMap!, at dateUpdated: Date!) {
        DispatchQueue.main.async {
            guard let newMap = map, let newMapImage = newMap.mapImage, newMap.mapType == .IMAGE else {
                return
            }
            
            self.ppm = newMap.ppm
            self.scaleX = Float(self.mapImageView.bounds.size.width/newMapImage.size.width)
            self.scaleY = Float(self.mapImageView.bounds.size.height/newMapImage.size.height)
            if let previousMap = self.currentMap{
                if(previousMap.mapId != newMap.mapId){
                    self.addIndoorMapView(url: newMap.mapURL)
                }
            }else{
                self.currentMap = newMap
                self.addIndoorMapView(url: newMap.mapURL)
            }
        }
    }
    
    func map(forMapId mapId: String) -> UIImage? {
        return nil
    }
    
    func shouldDownloadMap(_ manager: MSTCentralManager) -> MSTCentralManagerMapDataSourceOption {
        return MSTCentralManagerMapDataSourceOption.download
    }
    
    func mistManager(_ manager: MSTCentralManager!, didUpdateDRRelativeLocation drInfo: [AnyHashable : Any]!, inMaps maps: [Any]!, at dateUpdated: Date!) {
        
        guard let drInfo = drInfo,
            let snapped = drInfo["Raw"] as? [String : Any],
            let x = snapped["X"] as? Double,
            let y = snapped["Y"] as? Double else {
                print("Error: drInfo empty")
                return
        }
        
        DispatchQueue.main.async {
            let point = MSTPoint.init(x: x, andY: y)
            
            if point != nil{
                self.updatePoint(point:point!)
            }
        }
    }
    
    //MARK: - Other methods
    
    func updateSettings(_ settings:[AnyHashable: Any]){
        UserDefaults.standard.set(settings, forKey: kSetting)
        UserDefaults.standard.synchronize()
        localSettings = settings
    }
    
    
    func addIndoorMapView(url : String){
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
    
    func updatePoint(point: MSTPoint){
        guard let _=self.ppm,let _=self.scaleX,let _=self.scaleY else{return}
        let leEstCGPoint = self.scaleUp(self.convertMeters(toPixels: point.convertToCGPoint()))
        
        if let previousMarker = self.marker{
            previousMarker.removeFromSuperview()
        }
        
        self.marker = UIView(frame: CGRect(x: leEstCGPoint.x, y: leEstCGPoint.y, width: 10, height: 10))
        self.marker?.layer.cornerRadius = 5
        self.marker?.backgroundColor = UIColorFromHex(rgbValue: 0x0087CC)
        self.view.addSubview(self.marker!)
    }
    
    func convertMeters(toPixels point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x * CGFloat(ppm!), y: point.y * CGFloat(ppm!))
    }
    
    func scaleUp(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: CGFloat(Float(point.x) * scaleX!), y: CGFloat(Float(point.y) * scaleY!))
    }
    
    func UIColorFromHex(rgbValue: UInt32, alpha: Double = 1.0) -> UIColor {
           let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 256.0
           let green = CGFloat((rgbValue & 0xFF00) >> 8) / 256.0
           let blue = CGFloat(rgbValue & 0xFF) / 256.0

           return UIColor(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
       }
    
    
    //MARK: - Dismiss Controller
    
    @IBAction func dismissController(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

