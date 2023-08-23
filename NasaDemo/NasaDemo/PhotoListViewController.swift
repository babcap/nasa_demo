//
//  PhotoListViewController.swift
//  NasaDemo
//
//  Created by Arthur on 23.08.2023.
//

import UIKit

class PhotoListViewController: UIViewController {

    let viewModel: PhotoListViewModel

    init(viewModel: PhotoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
