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
    @IBOutlet private weak var datePicker: UIDatePicker!
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
        self.disableElementsIfNeeded()
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

        self.setupDatePicker()
    }

    private func setupSearchButton() {
        self.searchButton.setTitle("Search Photos", for: .normal)
        self.searchButton.tintColor = UIColor.init(red: 0, green: 0, blue: 153, alpha: 1)
        self.searchButton.layer.cornerRadius = 12
    }

    private func disableElementsIfNeeded() {
        let isEnabled = self.viewModel.searchModel != nil
        self.cameraTextField.isEnabled = isEnabled
        self.datePicker.isEnabled = isEnabled
        self.searchButton.isEnabled = isEnabled
    }

    private func setupDatePicker(){
        self.datePicker.maximumDate = Date()
        self.datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }

    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        self.viewModel.setDate(sender.date)
    }

    private func proceedSearch() {
        guard let photoListModel = self.viewModel.photoListViewModel() else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PhotoListViewController") as! PhotoListViewController
        controller.viewModel = photoListModel
        self.navigationController?.pushViewController(controller, animated: true)
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
            self.viewModel.setDate(Date())
            self.roverTextField.text = model.rover.rawValue
        case 2:
            self.viewModel.searchModel?.setCameraType(with: row)
            self.cameraTextField.text = self.viewModel.searchModel?.cameraType?.rawValue
        default: return
        }
        self.view.endEditing(false)
        self.disableElementsIfNeeded()
    }
}
