//
//  ViewController.swift
//  Mist-vbeacon-zone-notification-dr
//
//  Created by Pooja Gulabchand Mishra on 12/19/19.
//  Copyright © 2019 Pooja Gulabchand Mishra. All rights reserved.
//

import UIKit
import MistSDK

class ViewController: UIViewController,MSTCentralManagerDelegate,MSTCentralManagerMapDataSource {
    
    // Constants - location info
    let kOrgName = "name"
    let kOrgId = "org_id"
    let kSecret = "secret"
    let kSnapped = "Snapped"
    let kCoordinateX = "X"
    let kCoordinateY = "Y"
    let kBlueDotColorHex = 0x0087CC
    
    // Constants - vBeacon/zones
    let kZoneEvent = "zones-events"
    let kvbeaconEvent = "zone-event-vb"
    
    //client secret for test
    var clientSecret : String?
    
    var currentMap : MSTMap?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    var scaleX : Float?
    var scaleY : Float?
    var ppm : Double?
    var manager : MSTCentralManager?
    var marker : UIView!
    var mapImage:UIImage?
    
    @IBOutlet var backDropView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    
    
    //MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let secret = clientSecret{
            hardCodeReceivedQr(secret: secret)
        }
        mapImageView.contentMode = .scaleAspectFit
    }
    
    
    
    //MARK:- MSTCentralManagerDelegate
    
    // SDK cloud connection status
    func mistManager(_ manager: MSTCentralManager!, didConnect isConnected: Bool) {
        print("connected \(isConnected)")
    }
    
    // Get map info (mapId, mapURL, width, height, PPM - pixel per meter)
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
    
    // Get relative location (x, Y)
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
    
    
    // vBeacon and Zone notification
    func mistManager(_ manager: MSTCentralManager!, didReceiveNotificationMessage payload: [AnyHashable : Any]!) {
        DispatchQueue.global().sync {
            var messageToBeDisplayed = ""
            if let response = payload {
                if response is [String:AnyObject], let dict = (response as? [String:AnyObject]) {
                    if let message = dict["message"] as? [String : AnyObject], let type = dict["type"] as? String {
                        if type.compare(kZoneEvent) == .orderedSame {
                            if let _ = message["UserID"] as? String , let trigger = message["Trigger"] as? String, let extra = message["Extra"] as? String {
                                if trigger.compare("in") == .orderedSame {
                                    let extraParsed = extra.trimmingCharacters(in: .whitespacesAndNewlines)
                                    if extraParsed.compare("") != .orderedSame {
                                        messageToBeDisplayed = "You are \(trigger) \(extra)"
                                        
                                        //To dispay notification content
                                        //New code to display notification content at the bottom of the feature view controller:
                                        self.showNotificationBar(message: messageToBeDisplayed)
                                    } else {
                                        messageToBeDisplayed = "You're in Anonymous Zone"
                                        self.showNotificationBar(message: messageToBeDisplayed)
                                    }
                                }
                            }
                        } else if type.compare(kvbeaconEvent) == .orderedSame {
                            if let _ = message["UserID"] as? String , let trigger = message["proximity"] as? String, let extra = message["Extra"] as? String {
                                if (trigger.isEqual("near") || trigger.isEqual("immediate")){
                                    if let extra = message["Extra"], extra.isEmpty == true{
                                        showNotificationBar(message: "You're near an Anonymous virtual beacon")
                                    }else{
                                        showNotificationBar(message: "You're \(trigger) \(extra)")
                                    }
                                }
                            }
                        }
                    }
                }
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
    
    //MARK:-
    
    // Enroll your device with MobileSDK secret
    func hardCodeReceivedQr(secret: String){
        MSTOrgCredentialsManager.enrollDevice(withToken: secret, onComplete: { (response, error) in
            if error == nil, response != nil {
                
                let envType = secret.prefix(1)
                guard let response = response ,let org_id = response[self.kOrgId] as? String, let secret = response[self.kSecret] as? String else{return}
                
                DispatchQueue.main.async {
                    
                    self.manager = MSTCentralManager(orgID: org_id, andOrgSecret: secret)
                    self.manager?.delegate = self
                    self.manager?.setEnviroment(envType.uppercased()) // Set Environment for that Org belongs
                    self.manager?.setAppState(UIApplication.shared.applicationState) //Saves the App state - background or foreground
                    self.manager?.startLocationUpdates()
                }
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
     
    
    // Updates the Blue Dot on the floor map
    func updatePoint(point: MSTPoint){
        self.setFloorMapScaling()
        guard let _=ppm,let _=scaleX,let _=scaleY else{return}
        let leEstCGPoint = scaleUp(convertMeters(toPixels: point.convertToCGPoint()))
        
        if let previousMarker = marker{
            previousMarker.removeFromSuperview()
        }
        
        marker = UIView(frame: CGRect(x: leEstCGPoint.x, y: leEstCGPoint.y, width: 10, height: 10))
        marker.layer.cornerRadius = 5
        marker.backgroundColor = UIColorFromHex(rgbValue: UInt32(kBlueDotColorHex))
        self.backDropView.addSubview(marker)
        
    }
    
    // Displays the zone/vBeacon notification on the bottom bar
    func showNotificationBar(message : String){
        DispatchQueue.main.async {
            self.messageView.isHidden = false
            self.messageLabel.text = message
        }
    }
    
    //convertMeters, scaleUp and setFloorMapScaling are scaling methods:  Calc to convert FloorMap scale from Meter to pixel
    func convertMeters(toPixels point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x * CGFloat(ppm!), y: point.y * CGFloat(ppm!))
    }
    
    func scaleUp(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: CGFloat(Float(point.x) * scaleX!), y: CGFloat(Float(point.y) * scaleY!))
    }
    
    func setFloorMapScaling(){
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
   
    
    //MARK:-
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        if self.manager != nil {   self.manager?.stopLocationUpdates()   }
        self.dismiss(animated: true, completion: nil)
    }
}

