//
//  PhotoListViewController.swift
//  NasaDemo
//
//  Created by Arthur on 23.08.2023.
//

import UIKit

class PhotoListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!

    var viewModel: PhotoListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.getSearchPhotos()
        self.setupTableView()

        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(PhotoCell.nib, forCellReuseIdentifier: PhotoCell.identifier)
    }

    private func showImage(viewModel: PhotoCellViewModel, from view: UIView) {
        let imageInfo   = GSImageInfo(image: viewModel.image, imageMode: .aspectFit)
        let transitionInfo = GSTransitionInfo(fromView: view)
        let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
        
        imageViewer.dismissCompletion = {
            print("dismissCompletion")
        }
        
        present(imageViewer, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension PhotoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.photoCellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell else {
            return UITableViewCell()
        }
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.setup(with: cellVM)
        return cell
    }
}

extension PhotoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
        guard let cell = self.tableView.cellForRow(at: indexPath) else { return }
        let viewModel = viewModel.getCellViewModel(at: indexPath)
        self.showImage(viewModel: viewModel, from: cell)
    }
}

extension PhotoListViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView == tableView else { return }
        
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
        {
            self.viewModel.getSearchPhotos()
        }
    }
}
