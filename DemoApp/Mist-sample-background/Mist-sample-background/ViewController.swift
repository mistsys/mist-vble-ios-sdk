//
//  ViewController.swift
//  DemoApp
//
//  Created by Ajay Gantayet on 6/21/18.
//

import UIKit
import MistSDK


class ViewController: UIViewController,MSTCentralManagerDelegate,MSTCentralManagerMapDataSource ,CLLocationManagerDelegate{
    //client secret for test
    var clientSecret : String?
    var localSettings = [AnyHashable: Any]()
    
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    
    let kSettings = "com.mist.mistsdk_credentials"
    
    var currentMap : MSTMap?
    var backdropView : UIView?
    
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    var scaleX : Float?
    var scaleY : Float?
    var ppm : Double?
    var virtualBeacons : [AnyHashable : Any]?
    var manager: MSTCentralManager?
    @IBOutlet weak var mapImageView: UIImageView!
    var locationManager: CLLocationManager?
    
    var marker : UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backdropView = UIView.init()
        //self.messageView.isHidden = true
        
        if let secret = clientSecret{
            hardCodeReceivedQr(secret: secret)
        }
        
        mapImageView.contentMode = .scaleAspectFit
        initialize()
    }
    
    func initialize(){
        guard let clientSecret = clientSecret else {return}
        getLocationManager()
        //The above set of UUIDs have to be used as is
        locationManager?.delegate = self
        locationManager?.pausesLocationUpdatesAutomatically = false
        var beaconRegion: CLBeaconRegion? = nil
        if let anID = UUID(uuidString: clientSecret) {
            beaconRegion = CLBeaconRegion(proximityUUID: anID, identifier: clientSecret)
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
    
    
    func map(forMapId mapId: String) -> UIImage? {
        return nil
    }
    
    func mistManager(_ manager: MSTCentralManager!, didConnect isConnected: Bool) {
        print("connected \(isConnected)")
    }
    
    @IBAction func dissmissVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func mistManager(_ manager: MSTCentralManager!, didUpdate map: MSTMap!, at dateUpdated: Date!) {
        DispatchQueue.main.async {
            //guard let newMap = map,newMap.mapType == .IMAGE else { return }
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
    
    func addIndoorMapView(url : String){
        self.progressView.isHidden = true
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            guard let data = try? Data.init(contentsOf: URL(string: url)!) else { return }
            DispatchQueue.main.async {
                let image = UIImage.init(data: data)
                self.mapImageView.image = image;
            }
        }
    }
    
    func mistManager(_ manager: MSTCentralManager!, didUpdateRelativeLocation relativeLocation: MSTPoint!, inMaps maps: [Any]!, at dateUpdated: Date!) {
        DispatchQueue.main.async {
            let point:MSTPoint = relativeLocation
            self.updatePoint(point: point)
        }
        
    }
    
    func updatePoint(point: MSTPoint){
        guard let _=self.ppm,let _=self.scaleX,let _=self.scaleY else{return}
        var leEstCGPoint = self.scaleUp(self.convertMeters(toPixels: point.convertToCGPoint()))
        
        if let previousMarker = self.marker{
            previousMarker.removeFromSuperview()
        }
        
        self.marker = UIView(frame: CGRect(x: leEstCGPoint.x, y: leEstCGPoint.y, width: 10, height: 10))
        self.marker.layer.cornerRadius = 5
        self.marker.backgroundColor = self.UIColorFromHex(rgbValue: 0x0087CC)
        self.view.addSubview(self.marker)
    }
    
    func convertMeters(toPixels point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x * CGFloat(ppm!), y: point.y * CGFloat(ppm!))
    }
    
    func scaleUp(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: CGFloat(Float(point.x) * scaleX!), y: CGFloat(Float(point.y) * scaleY!))
    }
    
    func shouldDownloadMap(_ manager: MSTCentralManager) -> MSTCentralManagerMapDataSourceOption {
        return MSTCentralManagerMapDataSourceOption.download
    }
    
    func setAppWakeUp() {
        if (self.manager != nil) {
            self.manager?.wakeUpAppSetting(true)
            self.manager?.backgroundAppSetting(true)
            self.manager?.sendWithoutRest()
        }
    }
    
    
    func hardCodeReceivedQr(secret: String){
        MSTOrgCredentialsManager.enrollDevice(withToken: secret, onComplete: { (response, error) in
            if error == nil, response != nil {
                
                let envType = secret.substring(with: secret.startIndex..<secret.index(after: secret.startIndex))
                
                guard let response = response ,let name = response["name"],let org_id = response["org_id"] as? String, let secret = response["secret"] as? String else{return}
                
                DispatchQueue.main.async {
                    let dict = ["name"          :   name,
                                "tokenID"       :   org_id,
                                "tokenSecret"   :   secret,
                                "tokenEnvType"  :   envType]
                    self.manager = MSTCentralManager.init(orgID: org_id, andOrgSecret: secret)
                    self.manager?.delegate = self
                    self.manager?.setAppState(UIApplication.shared.applicationState)
                    self.setAppWakeUp()
                    self.updateSettings(dict)
                    self.manager?.startLocationUpdates()
                   

                }
                
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
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
}

