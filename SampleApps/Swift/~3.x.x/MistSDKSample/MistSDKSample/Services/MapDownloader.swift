//
//  MapDownloader.swift
//  SampleBlueDotExperience
//
//  Created by Rajesh Vishwakarma on 31/01/23.
//

import Foundation
import UIKit

typealias DownloadableResposneHandler = (_ image: UIImage?, _ error: Error?) -> Void


enum ImageError: Error {
    case unknown
}

protocol Downloadable {
    func download(url: URL, onCompletion: @escaping DownloadableResposneHandler)
}

class MapDownloader: Downloadable {
    
    func download(url: URL, onCompletion: @escaping DownloadableResposneHandler) {
        let session = URLSession(configuration: .default)
        let request = URLRequest(url: url)
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                //debugPrint("Error: Unable to download map image with url \(url.absoluteString)")
                onCompletion(nil, error)
                return
            }
            
            guard let imageData = data else {
                //debugPrint("Error: Map image data is nil")
                onCompletion(nil, ImageError.unknown)
                return
            }
            
            let image = UIImage(data: imageData)
            onCompletion(image, nil)
        }
        
        dataTask.resume()
    }
}

