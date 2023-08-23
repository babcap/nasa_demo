//
//  ChooseParamsViewModel.swift
//  NasaDemo
//
//  Created by Arthur on 23.08.2023.
//

import Foundation

class ChooseParamsViewModel {
    var searchModel: SearchModel?

    func photoListViewModel() -> PhotoListViewModel? {
        guard let model = searchModel else { return nil }
        return PhotoListViewModel(model: model)
    }
}
