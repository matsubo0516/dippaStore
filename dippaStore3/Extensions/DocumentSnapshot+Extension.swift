//
//  DocumentSnapshot+Extension.swift
//  dippaStore3
//
//  Created by 松本直樹 on 2019/01/07.
//  Copyright © 2019年 松本直樹. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum DippaError: Error {
    case error
}

extension DocumentSnapshot {

    func decoded<Type: Decodable>() throws -> Type {
        guard var json = data(), exists else {
            throw DippaError.error
        }

        // dippaではidの保持が必要
        json["id"] = documentID

        let jsonData = try JSONSerialization.data(withJSONObject: json)
        let object = try JSONDecoder().decode(Type.self, from: jsonData)

        return object
    }

}
