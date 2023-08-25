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
    
}
