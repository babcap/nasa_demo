//
//  PhotosResponse.swift
//  NasaDemo
//
//  Created by Arthur on 24.08.2023.
//

import Foundation

typealias Photos = [Photo]

// MARK: - PhotosResponse
struct PhotosResponse: Codable {
    let photos: Photos
}

// MARK: - Photo
struct Photo: Codable {
    let id, sol: Int
    let camera: PhotoCamera
    let imgSrc: String
    let earthDate: String
    let rover: RoverModel

    enum CodingKeys: String, CodingKey {
        case id, sol, camera
        case imgSrc = "img_src"
        case earthDate = "earth_date"
        case rover
    }
}

// MARK: - PhotoCamera
struct PhotoCamera: Codable {
    let id: Int
    let name: String
    let roverID: Int
    let fullName: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case roverID = "rover_id"
        case fullName = "full_name"
    }
}

// MARK: - Rover
struct RoverModel: Codable {
    let id: Int
    let name, landingDate, launchDate, status: String
    let maxSol: Int
    let maxDate: String
    let totalPhotos: Int
    let cameras: [CameraElement]

    enum CodingKeys: String, CodingKey {
        case id, name
        case landingDate = "landing_date"
        case launchDate = "launch_date"
        case status
        case maxSol = "max_sol"
        case maxDate = "max_date"
        case totalPhotos = "total_photos"
        case cameras
    }
}

// MARK: - CameraElement
struct CameraElement: Codable {
    let name, fullName: String

    enum CodingKeys: String, CodingKey {
        case name
        case fullName = "full_name"
    }
}
