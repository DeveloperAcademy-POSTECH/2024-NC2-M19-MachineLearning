# 2024-NC2-M19-MachineLearning

## 🎥 Youtube Link

(추후 만들어진 유튜브 링크 추가) <br/>

## 💡 About Augmented Reality

>  **Core ML** : AI 모델을 Apple 디바이스와 쉽게 통합할 수 있게 하는 강력한 프레임워크 <br/>
>  **Create ML** : 코드작성 없이도, 원하는 AI 모델을 쉽게 만들어주는 도구
> 
> <img width="1841" alt="ML소개" src="https://github.com/DeveloperAcademy-POSTECH/2024-NC2-M19-MachineLearning/assets/156973592/0f461bb5-d45d-4cfc-ae17-6bdededda83b">
> 
> ML의 **4가지 분류**
> - Vision: 컴퓨터 비전을 사용하여 이미지와 비디오를 처리하고 분석
> - Natural Language: 단어 포함, 분류와 같은 다양한 방법으로 텍스트를 처리하고 이해
> - Speech: 다양한 언어에 대한 음성 인식 및 현저성 기능을 활용
> - Sound: 오디오를 분석하고 웃음이나 박수같은 특정 유형으로 분류/인식 <br/>

## 🎯 What we focus on?

> Create ML에서 Image Classification 템플릿을 활용하여 직접 AI 모델을 만들고, Vision 프레임워크인 VNCoreMLContainer를 활용하여 직접 만든 ML 모델을 앱에 적용한다. <br/>

## 💼 Use Case
> **😽 포스텍 고양이들을 구분하고 만난 고양이들을 기록하자!** <br/>

## 🖼️ Prototype

<img width="1247" alt="prototype" src="https://github.com/DeveloperAcademy-POSTECH/2024-NC2-M19-MachineLearning/assets/156973592/57015213-4537-427f-b256-4228af19cd7e">

[RPReplay_Final1718841098.MP4](https://prod-files-secure.s3.us-west-2.amazonaws.com/2e999faf-43aa-426e-ba81-0a9f876c0c58/669ae909-aed9-494d-877e-bd511374bf7e/RPReplay_Final1718841098.mp4)
<br/>

## 🛠️ About Code
```swift
import Vision

extension MosuDataModel {
    func detect(image: CIImage, completion: @escaping (String) -> Void) {

        // CoreML의 모델로 사용할 PocatClassifier2를 coreMLModel 객체로 생성 후,
        // Vision 프레임워크인 VNCoreMLModel 컨테이너를 사용하여 CoreML의 model에 접근한다.
        guard let coreMLModel = try? PocatClassifier2(configuration: MLModelConfiguration()),
              let visionModel = try? VNCoreMLModel(for: coreMLModel.model) else {
            fatalError("Loading CoreML Model Failed")
        }

        // Vision을 이용해 이미치 처리를 요청
        let request = VNCoreMLRequest(model: visionModel) { request, error in
            guard error == nil else {
                fatalError("Failed Request")
            }

            // 식별자의 이름(고양이 이름)을 확인하기 위해 VNClassificationObservation로 변환해준다.
            guard let classification = request.results as? [VNClassificationObservation] else {
                fatalError("Faild convert VNClassificationObservation")
            }

            // 머신러닝을 통한 결과값 프린트
            print(classification)
            if let firstItem = classification.first { // 가장 확률이 높은 결과를 firstItem에 저장
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
```
