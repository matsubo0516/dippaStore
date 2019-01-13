//
//  Shop.swift
//  dippaStore3
//
//  Created by 松本直樹 on 2019/01/07.
//  Copyright © 2019年 松本直樹. All rights reserved.
//

import UIKit

struct Shop: Codable {
    let id: String?
    let name: String
    let phone: String
    let address: String
    let mondayOpenHours: String?
    let tuesdayOpenHours: String?
    let wednesdayOpenHours: String?
    let thursdayOpenHours: String?
    let fridayOpenHours: String?
    let saturdayOpenHours: String?
    let sundayOpenHours: String?
    let holidayOpenHours: String?

    init(id: String?, name: String, phone: String, address: String) {
        self.id = id
        self.name = name
        self.phone = phone
        self.address = address
        self.mondayOpenHours = nil
        self.tuesdayOpenHours = nil
        self.wednesdayOpenHours = nil
        self.thursdayOpenHours = nil
        self.fridayOpenHours = nil
        self.saturdayOpenHours = nil
        self.sundayOpenHours = nil
        self.holidayOpenHours = nil
    }

    func toData() -> [String: Any] {
        return [
            "id": self.id as Any,
            "name": self.name,
            "phone": self.phone,
            "address": self.address,
            "mondayOpenHours": self.mondayOpenHours as Any,
            "tuesdayOpenHours": self.tuesdayOpenHours as Any,
            "wednesdayOpenHours": self.wednesdayOpenHours as Any,
            "thursdayOpenHours": self.thursdayOpenHours as Any,
            "fridayOpenHours": self.fridayOpenHours as Any,
            "saturdayOpenHours": self.saturdayOpenHours as Any,
            "sundayOpenHours": self.sundayOpenHours as Any,
            "holidayOpenHours": self.holidayOpenHours as Any,
        ]
    }
}
