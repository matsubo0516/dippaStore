//
//  Menu.swift
//  dippaStore3
//
//  Created by 松本直樹 on 2019/01/07.
//  Copyright © 2019年 松本直樹. All rights reserved.
//

import UIKit

struct Menu: Codable {
    let id: String?
    let name: String
    let photo: String
    let rawPhoto: String
    let price: Int
    let shopId: String

    init(id: String?, name: String, photo: String, rawPhoto: String, price: Int, shopId: String) {
        self.id = id
        self.name = name
        self.photo = photo
        self.rawPhoto = rawPhoto
        self.price = price
        self.shopId = shopId
    }

    func toData() -> [String: Any] {
        return [
            "id": self.id as Any,
            "name": self.name,
            "photo": self.photo,
            "rawPhoto": self.rawPhoto,
            "price": self.price,
            "shopId": self.shopId,
        ]
    }
}
