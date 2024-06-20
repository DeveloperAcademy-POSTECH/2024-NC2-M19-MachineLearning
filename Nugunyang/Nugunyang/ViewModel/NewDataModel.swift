//
//  NewDataModel.swift
//  Nugunyang
//
//  Created by 원주연 on 6/19/24.
//

import Foundation
import Vision

extension NewDataModel {
    func detect(image: CIImage, completion: @escaping (String) -> Void) {
        // CoreML의 모델인 FlowerClassifier를 객체를 생성 후,
        // Vision 프레임워크인 VNCoreMLModel 컨터이너를 사용하여 CoreML의 model에 접근한다.
        guard let coreMLModel = try? MyCatImageClassifier(configuration: MLModelConfiguration()),
              let visionModel = try? VNCoreMLModel(for: coreMLModel.model) else {
            fatalError("Loading CoreML Model Failed")
        }
        // Vision을 이용해 이미치 처리를 요청
        let request = VNCoreMLRequest(model: visionModel) { request, error in
            guard error == nil else {
                fatalError("Failed Request")
            }
            // 식별자의 이름(꽃 이름)을 확인하기 위해 VNClassificationObservation로 변환해준다.
            guard let classification = request.results as? [VNClassificationObservation] else {
                fatalError("Faild convert VNClassificationObservation")
            }
            // 머신러닝을 통한 결과값 프린트
            print(classification)
            if let firstItem = classification.first {
                print(firstItem.identifier.capitalized)
                var result = firstItem.identifier.capitalized
                result += " "
                result += firstItem.confidence.formatted()
                completion(firstItem.identifier.capitalized)
            } else {
                completion("못찾음 ㅠ")
            }

        }

        // 이미지를 받아와서 perform을 요청하여 분석한다. (Vision 프레임워크)
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
}
