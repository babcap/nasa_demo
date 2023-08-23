//
//  ChooseParamsViewController.swift
//  NasaDemo
//
//  Created by Arthur on 23.08.2023.
//

import UIKit

class ChooseParamsViewController: UIViewController {
    @IBOutlet private weak var roverTextField: UITextField!
    @IBOutlet private weak var cameraTextField: UITextField!
    @IBOutlet private weak var dateTextField: UITextField!
    @IBOutlet private  weak var searchButton: UIButton!

    private let roverPicker = UIPickerView()
    private let cameraPicker = UIPickerView()

    private lazy var viewModel = {
        ChooseParamsViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupPickers()
        self.setupSearchButton()
        self.disableTextFieldIfNeeded()
    }

    private func setupPickers() {
        self.roverPicker.dataSource = self
        self.roverPicker.delegate = self
        self.cameraPicker.dataSource = self
        self.cameraPicker.delegate = self
        self.roverPicker.tag = 1
        self.cameraPicker.tag = 2;

        self.roverTextField.inputView = self.roverPicker
        self.cameraTextField.inputView = self.cameraPicker
    }

    private func setupSearchButton() {
        self.searchButton.setTitle("Search Photos", for: .normal)
        self.searchButton.tintColor = UIColor.init(red: 0, green: 0, blue: 153, alpha: 1)
        self.searchButton.layer.cornerRadius = 12
    }

    private func disableTextFieldIfNeeded() {
        self.cameraTextField.isEnabled = self.viewModel.searchModel != nil
    }

    private func proceedSearch() {
        guard let photoListModel = self.viewModel.photoListViewModel() else { return }
        let vc = PhotoListViewController(viewModel: photoListModel)
        let navigation = UINavigationController(rootViewController: vc)
        self.present(navigation, animated: true, completion: nil)
    }

    @IBAction private func onSearchButton(_ sender: Any) {
        self.proceedSearch()
    }
}

extension ChooseParamsViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return Rover.allCases.count
        case 2:
            return self.viewModel.searchModel?.rover.cameras.count ?? 0
        default: return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return Rover.allCases[row].rawValue
        case 2:
            return self.viewModel.searchModel?.rover.cameras[row].rawValue
        default: return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            let model = SearchModel(rover: Rover.allCases[row])
            self.viewModel.searchModel = model
            self.roverTextField.text = model.rover.rawValue
        case 2:
            self.viewModel.searchModel?.setCameraType(with: row)
            self.cameraTextField.text = self.viewModel.searchModel?.cameraType?.rawValue
        default: return
        }
        self.view.endEditing(false)
        self.disableTextFieldIfNeeded()
    }
}
