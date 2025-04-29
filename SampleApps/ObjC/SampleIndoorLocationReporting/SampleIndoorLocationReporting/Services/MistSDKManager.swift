//
//  MistSDKManager.swift
//  SampleBlueDotExperience
//
//  Created by Akhil Rana on 02/04/25.
//

import Foundation
import MistSDK

@objc public protocol MistSDKManagerDelegate: NSObjectProtocol {
    func didUpdateMap(_ mapURL: URL)
    func didUpdateLocation(_ location: CGPoint)
    func didFailWithError(_ error: String)
    func didUpdateVirtualBeaconList(_ beacons: [String])
    func didEnterZone(_ zoneName: String)
    func didExitZone(_ zoneName: String)
    func didRangeVirtualBeacon(_ beaconName: String)
    func didReceiveClientInfo(_ clientName: String)
}

public class MistSDKManager: NSObject {
    private let mistManager = IndoorLocationManager.shared
    private let sdkConfig: Mist.Configuration
    private var currentMap: Mist.Map?
    @objc public weak var delegate: MistSDKManagerDelegate?

    @objc public init(token: String, orgId: String) {
        self.sdkConfig = .default(orgId: orgId, sdkToken: token)
    }

    @objc public func start() {
        mistManager.start(with: sdkConfig, delegate: self)
    }

    @objc public func stop() {
        mistManager.stop()
    }
}

extension MistSDKManager: IndoorLocationDelegate {
    public func didReceive(event: Mist.Event) {
        switch event {
        case .onReceivedClientInfo(let client):
            delegate?.didReceiveClientInfo(client.name ?? "Unknown Client")

        case .onReceivedAllMaps(let maps):
            debugPrint(">>> onReceivedAllMaps \(maps.count)")

        case .onMapUpdate(let map):
            guard let url = map.url, let mapUrl = URL(string: url) else { return }
            currentMap = map
            delegate?.didUpdateMap(mapUrl)

        case .onUpdateVirtualBeaconList(let vBeacons):
            let beaconNames = vBeacons.map { $0.name ?? "Unknown Beacon" }
            delegate?.didUpdateVirtualBeaconList(beaconNames)

        case .onRelativeLocationUpdate(let relativeLocation):
            guard let map = currentMap, let ppm = map.ppm else { return }
            let location = CGPoint(x: relativeLocation.x * ppm, y: relativeLocation.y * ppm)
            delegate?.didUpdateLocation(location)

        case .onEnterZone(let zone):
            delegate?.didEnterZone(zone.name ?? "Unknown Zone")

        case .onExitZone(let zone):
            delegate?.didExitZone(zone.name ?? "Unknown Zone")

        case .onRangeVirtualBeacon(let vBeacon):
            delegate?.didRangeVirtualBeacon(vBeacon.name ?? "Unknown Beacon")

        case .onError(let error):
            delegate?.didFailWithError(error.localizedDescription)

        default:
            break
        }
    }
}
