//
//  Models.swift
//  NasaDemo
//
//  Created by Arthur on 23.08.2023.
//

import Foundation

enum Rover: String, CaseIterable {
    case curiosity = "Curiosity"
    case opportunity = "Opportunity"
    case spirit = "Spirit"

    var cameras: [CameraType] {
        switch self {
        case .curiosity:
            return [.fhaz, .rhaz, .mast, .chemcam, .mahli, .mardi, .navcam]
        case .opportunity:
            return [.fhaz, .rhaz, .navcam, .pancam, .minutes]
        case .spirit:
            return [.fhaz, .rhaz, .navcam, .pancam, .minutes]
        }
    }
}

enum CameraType: String {
    case fhaz = "Front Hazard Avoidance Camera"
    case rhaz = "Rear Hazard Avoidance Camera"
    case mast = "Mast Camera"
    case chemcam = "Chemistry and Camera Complex"
    case mahli = "Mars Hand Lens Imager"
    case mardi = "Mars Descent Imager"
    case navcam = "Navigation Camera"
    case pancam = "Panoramic Camera"
    case minutes = "Miniature Thermal Emission Spectrometer (Mini-TES)"
}

struct SearchModel {
    let rover: Rover
    private (set) var cameraType: CameraType?
    var date: String?

    mutating func setCameraType(with index: Int) {
        cameraType = rover.cameras[index]
    }

    func queryParams() -> [URLQueryItem] {
        var paramsArray = [URLQueryItem]()

        if let cameraType = cameraType {
            paramsArray.append(URLQueryItem(name: "camera", value: "\(cameraType)"))
        }
        if let dateString = date {
            paramsArray.append(URLQueryItem(name: "earth_date", value: "\(dateString)"))
        }
        return paramsArray
    }
}

