//
//  PocatModel.swift
//  Nugunyang
//
//  Created by 원주연 on 6/20/24.
//

import Foundation
import SwiftData

let assetNames: [String: String] = [
    "고등어": "gray",
    "깜냥이1": "black1",
    "깜냥이2": "black2",
    "깜냥이3": "black3",
    "노벨이": "nobel",
    "다크초코": "brown2",
    "삼색이": "samsec",
    "인절미": "injeolmi",
    "치즈스틱": "cheesestick",
]

let fadedAssetNames: [String: String] = [
    "고등어_0": "gray_faded",
    "깜냥이1_0": "black1_faded",
    "깜냥이2_0": "black2_faded",
    "깜냥이3_0": "black3_faded",
    "노벨이_0": "nobel_faded",
    "다크초코_0": "brown2_faded",
    "삼색이_0": "samsec_faded",
    "인절미_0": "injeolmi_faded",
    "치즈스틱_0": "cheesestick_faded",
]

@Model
class Cat {
    let name: String
    let name_0: String
    var meetCount: Int = 0
    let index: Int
    
    var realName: String {
        switch name {
        case "깜냥이1": return "바미"
        case "깜냥이2": return "까미"
        case "깜냥이3": return "나미"
        default: return name
        }
    }

    var assetName: String {
        assetNames[name] ?? "nyan"
    }

    var fadedAssetName: String {
        fadedAssetNames[name_0] ?? "nyan"
    }

    init(name: String, name_0: String, meetCount: Int, index: Int) {
        self.name = name
        self.name_0 = name_0
        self.meetCount = meetCount
        self.index = index
    }
}
 /*
  처음 생성 시
  */

// @Query var cats: [Cat]
//
//
// if cats.empty { 처음 데이터 넣어주기() }
//
// func 처음 데이터 넣어주기() {
//     cats.append(Cat("노벨이", ...))
// }

//struct 노벨이 {
//    static let name = "노벨이"
//    static let count = 0
//}
