//
//  PhotoListViewModel.swift
//  NasaDemo
//
//  Created by Arthur on 23.08.2023.
//

import UIKit

class PhotoListViewModel {
    let searchModel: SearchModel
    private var photoService: PhotosServiceProtocol
    let downloadManager = DownloadManager()

    var reloadTableView: (() -> Void)?

    var photos = Photos()
    private var currentPage = 1
    private var isLoading = false

    var photoCellViewModels = [PhotoCellViewModel]() {
        didSet {
            self.reloadTableView?()
        }
    }

    init(model: SearchModel, photoService: PhotosServiceProtocol = PhotosService()) {
        self.searchModel = model
        self.photoService = photoService
    }

    func getSearchPhotos() {
        guard !self.isLoading else { return }

        self.isLoading = true
        self.photoService.getPhotos(with: self.searchModel, page: self.currentPage) { success, model, error in
            
            self.isLoading = false
            if success, let photos = model {
                self.currentPage += 1
                self.fetchData(photos: photos)
            } else {
                print(error!)
            }
        }
    }

    func fetchData(photos: Photos) {
        self.photos = photos
        var cellVM = [PhotoCellViewModel]()
        
        let completion = BlockOperation {
            for photo in photos {
                guard let pathComponent = URL(string: photo.imgSrc)?.lastPathComponent else { continue }
                let manager = FileManager.default
                do {
                    let destinationURL = try manager
                        .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                        .appendingPathComponent(pathComponent)
                    guard let data = try? Data(contentsOf: destinationURL) else { return }

                    let image = UIImage(data: data)
                    cellVM.append(.init(id: photo.id, name: photo.camera.fullName, image: image ?? UIImage()))
                    
                } catch {
                    print("Error:", error)
                }

            }
            self.photoCellViewModels.append(contentsOf: cellVM)
            self.reloadTableView?()
        }
        
        for photo in photos {
            guard let url = URL(string: photo.imgSrc) else { continue }
            let operation = downloadManager.queueDownload(url)
            completion.addDependency(operation)
        }

        OperationQueue.main.addOperation(completion)
    }

    func getCellViewModel(at indexPath: IndexPath) -> PhotoCellViewModel {
        return photoCellViewModels[indexPath.row]
    }
}
