//
//  MenuTableViewCell.swift
//  dippaStore3
//
//  Created by 松本直樹 on 2019/01/07.
//  Copyright © 2019年 松本直樹. All rights reserved.
//

import UIKit
import Kingfisher

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var menuNameLabel: UILabel!
    @IBOutlet weak var menuPriceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        menuImageView.layer.cornerRadius = 8.0
        menuImageView.clipsToBounds = true
    }

    func setup(with menu: Menu) {
        let url = URL(string: menu.rawPhoto)
        menuImageView.kf.setImage(with: url)
        menuNameLabel.text = menu.name
        menuPriceLabel.text = "¥\(menu.price)"
    }

}
