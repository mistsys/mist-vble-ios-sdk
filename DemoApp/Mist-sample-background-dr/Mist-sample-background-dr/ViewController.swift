//
//  ViewController.swift
//  Mist-sample-background-dr
//
//  Created by Pooja Gulabchand Mishra on 12/18/19.
//  Copyright © 2019 Pooja Gulabchand Mishra. All rights reserved.
//

import UIKit
import MistSDK

class ViewController: UIViewController, MSTCentralManagerDelegate, MSTCentralManagerMapDataSource {
    
    @IBOutlet var backDropView: UIView!
    @IBOutlet var mapImageView: UIImageView!
    @IBOutlet var progressView: UIActivityIndicatorView!
    
    //Constants - location response
    let kOrgName = "name"
    let kOrgId = "org_id"
    let kSecret = "secret"
    let kSnapped = "Snapped"
    let kCoordinateX = "X"
    let kCoordinateY = "Y"
    let kBlueDotColorHex = 0x0087CC
    
    var sdkSecret : String?
    var marker : UIView!
    var currentMap : MSTMap?
    var point : MSTPoint?
    var manager : MSTCentralManager?
    var mapImage: UIImage?
    
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    var scaleX : Float?
    var scaleY : Float?
    var ppm: Double?  // Pixel per meter
    
    //MARK:- ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //enroll the sdk secret
        if let sdkSecret = sdkSecret{
            enrollDeviceWithSecret(secret: sdkSecret)
        }
        mapImageView.contentMode = .scaleAspectFit
    }
    
    
    //MARK: - MSTCentralManagerDelegate
    
    func mistManager(_ manager: MSTCentralManager!, didConnect isConnected: Bool) {
        print("isConnected check : \(isConnected)")
    }
    
    func mistManager(_ manager: MSTCentralManager!, didUpdateDRMap map: MSTMap!, at dateUpdated: Date!) {
        DispatchQueue.main.async {
            guard let newMap = map, let mapURL = map.mapURL, newMap.mapType == .IMAGE else {
                return
            }
            //Conversion of image to pixel per meter
            self.ppm = newMap.ppm
            
            // download image using map url
            self.downloadMap(with:URL(string: mapURL)) { (data, urlResponse, error) in
                let mapImage = UIImage(data: data!)
                
                DispatchQueue.main.async {
                    self.progressView.isHidden = true
                    
                    //add the image to mapImageView
                    self.mapImage = mapImage
                    self.mapImageView.image = mapImage
                    
                    //Update the backdropview and mapImageview based on image size
                    self.updateBackdropFrame()
                    
                }
            }
        }
    }
 
      
    func mistManager(_ manager: MSTCentralManager!, didUpdateDRRelativeLocation drInfo: [AnyHashable : Any]!, inMaps maps: [Any]!, at dateUpdated: Date!) {
        // Fetching location - Snapped data from the response
        guard let drInfo = drInfo,
            let snapped = drInfo[kSnapped] as? [String : Any],
            let x = snapped[kCoordinateX] as? Double,
            let y = snapped[kCoordinateY] as? Double else {
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
    
    //MARK: - MSTCentralManagerMapDataSource
    
    func map(forMapId mapId: String) -> UIImage? {
        return nil
    }
    
    func shouldDownloadMap(_ manager: MSTCentralManager) -> MSTCentralManagerMapDataSourceOption {
        return MSTCentralManagerMapDataSourceOption.download
    }
    
    //MARK: -
    
    // Enroll your device with MobileSDK secret 
    func enrollDeviceWithSecret(secret : String)
    {
        MSTOrgCredentialsManager.enrollDevice(withToken: secret, onComplete:{ response, error in
            guard error == nil, response != nil , let env = secret.first else
            {
                print("Error: unable to register org \(String(describing: error))")
                return
            }
            
            guard let response = response,
                let _ = response[self.kOrgName] as? String,
                let orgID = response[self.kOrgId] as? String,
                let secret = response[self.kSecret] as? String else{
                    print("Error: unable to fetch the org_id and secret")
                    return
            }
            
            DispatchQueue.main.async {
                
                self.manager = MSTCentralManager(orgID: orgID, andOrgSecret: secret)
                self.manager?.delegate = self
                self.manager?.setEnviroment(env.uppercased())
                self.manager?.setAppState(UIApplication.shared.applicationState)
                self.manager?.startLocationUpdates()
                self.manager?.wakeUpAppSetting(true)
                self.manager?.sendWithoutRest()
                
            }
        })
    }
    
    // Download the Map image
    func downloadMap(with url: URL?, onComplete complete: @escaping (_ data: Data?, _ urlResponse: URLResponse?, _ error: Error?) -> Void) {
         let session = URLSession(configuration: URLSessionConfiguration.default)
         if let url = url {
             session.dataTask(with: url, completionHandler: complete).resume()
         }
         session.finishTasksAndInvalidate()
     }
    
    
    // Updates the Blue-Dot(point) on the floor map
    func updatePoint(point: MSTPoint){
        self.setFloormapScaling()
        guard let _ = ppm, let _ = scaleX, let _ = scaleY else {
            return
        }
        
        let leEstCGPoint = scaleUp(convertMeters(toPixels: point.convertToCGPoint()))
        if let previousMarker = marker {
            previousMarker.removeFromSuperview()
        }
        self.marker = UIView(frame: CGRect(x: leEstCGPoint.x, y: leEstCGPoint.y, width: 10, height: 10))
        self.marker.layer.cornerRadius = 5
        self.marker.backgroundColor = UIColorFromHex(rgbValue: UInt32(kBlueDotColorHex))
        
        self.backDropView.addSubview(self.marker)
    }
    
    //convertMeters, scaleUp and setFloorMapScaling are scaling methods:  Calc to convert FloorMap scale from Meter to pixel
    func convertMeters(toPixels point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x * CGFloat(ppm!), y: point.y * CGFloat(ppm!))
    }
    
    func scaleUp(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: CGFloat(Float(point.x) * scaleX!), y: CGFloat(Float(point.y) * scaleY!))
    }
    
    func setFloormapScaling(){
        self.scaleX = Float(self.backDropView.bounds.size.width / (mapImage?.size.width ?? 0))
        self.scaleY = Float(self.backDropView.bounds.size.height / (mapImage?.size.height ?? 0))
    }
    
    // Setting constraint for backDropView based on image size
     func updateBackdropFrame()  {
         let floorViewRatio = self.backDropView.bounds.size.width/self.backDropView.bounds.size.height
         let imageRatio = mapImage!.size.width/mapImage!.size.height
         
         self.backDropView.translatesAutoresizingMaskIntoConstraints = false
         
         if imageRatio >= floorViewRatio {
             self.widthConstraint = NSLayoutConstraint.init(item: self.backDropView!, attribute: .width, relatedBy: .equal, toItem: nil, attribute:.notAnAttribute, multiplier: 1, constant: self.view.bounds.size.width-10)
             self.heightConstraint = NSLayoutConstraint.init(item: self.backDropView!, attribute: .height, relatedBy: .equal, toItem: self.mapImageView, attribute: .width, multiplier: mapImage!.size.height/mapImage!.size.width, constant: 0)
         }
         else {
             self.widthConstraint = NSLayoutConstraint.init(item: self.backDropView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.view.bounds.size.height-10)
             self.heightConstraint = NSLayoutConstraint.init(item: self.backDropView!, attribute: .width, relatedBy: .equal, toItem: self.mapImageView!, attribute: .height, multiplier: mapImage!.size.width/mapImage!.size.height, constant: 0)
         }
         
         self.backDropView.addConstraint(self.widthConstraint!)
         self.backDropView.addConstraint(self.heightConstraint!)
         self.mapImageView.centerXAnchor.constraint(lessThanOrEqualTo: self.view.centerXAnchor).isActive = true
         self.mapImageView.centerYAnchor.constraint(lessThanOrEqualTo: self.view.centerYAnchor, constant: 0).isActive = true
     }
    
    //MARK: -
    
    func UIColorFromHex(rgbValue: UInt32, alpha: Double = 1.0) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8) / 256.0
        let blue = CGFloat(rgbValue & 0xFF) / 256.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
    }
    
    @IBAction func dismissController(_ sender: Any) {
        if self.manager != nil{    self.manager?.stopLocationUpdates()  }
        dismiss(animated: true, completion: nil)
    }
}

