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
    let insidePhoto: String
    let outsidePhoto: String

    init(id: String?,
         name: String,
         phone: String,
         address: String,
         mondayOpenHours: String?,
         tuesdayOpenHours: String?,
         wednesdayOpenHours: String?,
         thursdayOpenHours: String?,
         fridayOpenHours: String?,
         saturdayOpenHours: String?,
         sundayOpenHours: String?,
         holidayOpenHours: String?,
         insidePhoto: String,
         outsidePhoto: String){
        self.id = id
        self.name = name
        self.phone = phone
        self.address = address
        self.mondayOpenHours = mondayOpenHours
        self.tuesdayOpenHours = tuesdayOpenHours
        self.wednesdayOpenHours = wednesdayOpenHours
        self.thursdayOpenHours = thursdayOpenHours
        self.fridayOpenHours = fridayOpenHours
        self.saturdayOpenHours = saturdayOpenHours
        self.sundayOpenHours = sundayOpenHours
        self.holidayOpenHours = holidayOpenHours
        self.insidePhoto = insidePhoto
        self.outsidePhoto = outsidePhoto
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
            "insidePhoto": self.insidePhoto,
            "outsidePhoto": self.outsidePhoto
        ]
    }
}
