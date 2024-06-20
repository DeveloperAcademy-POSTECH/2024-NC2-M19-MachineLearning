//
//  PocatDataModel.swift
//  Nugunyang
//
//  Created by 원주연 on 6/20/24.
//

import Foundation
import SwiftData

@Model
class Cat {
    let name: String
    let name_0: String
    var meetCount: Int = 0
    
    init(name: String, name_0: String, meetCount: Int) {
        self.name = name
        self.name_0 = name_0
        self.meetCount = meetCount
    }
}
 /*
  처음 생성 시
  */

// @Query var cats: [Cat]
//

// if cats.empty { 처음 데이터 넣어주기() }

// func 처음 데이터 넣어주기() {
//     cats.append(Cat("노벨이", ...))
// }

struct 노벨이 {
    static let name = "노벨이"
    static let count = 0
}
