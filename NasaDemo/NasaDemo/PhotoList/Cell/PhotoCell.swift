//
//  PhotoCell.swift
//  NasaDemo
//
//  Created by Arthur on 24.08.2023.
//

import UIKit

class PhotoCell: UITableViewCell {
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var idLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    
    static var identifier: String { return String(describing: self) }
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }

    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }

    func initView() {
        backgroundColor = .clear

        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.idLabel.text = nil
        self.nameLabel.text = nil
        self.photoImageView.image = nil
    }

    func setup(with model: PhotoCellViewModel) {
        idLabel.text = "\(model.id)"
        nameLabel.text = model.name
        photoImageView.image = model.image
    }
}
