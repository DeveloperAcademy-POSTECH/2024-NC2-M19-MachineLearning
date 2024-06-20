//
//  MosuDataModel.swift
//  Nugunyang
//
//  Created by 원주연 on 6/18/24.
//

import AVFoundation
import SwiftUI
import os.log

final class MosuDataModel: ObservableObject {
    let camera = MosuCamera()

    @Published var viewfinderImage: Image?
    @Published var thumbnailImage: Image?
    @Published var resultString: String = "Initial"

    var isPhotosLoaded = false
    
//    // 줌 기능
//    var currentZoomFactor: CGFloat = 1.0
//    var lastScale: CGFloat = 1.0
//    
//
//    // ✅ 추가: onChange에 호출하는 줌 기능
//        func zoom(factor: CGFloat) {
//            let delta = factor / lastScale
//            lastScale = factor
//            
//            let newScale = min(max(currentZoomFactor * delta, 1), 5)
//            camera.zoom(newScale)
//            currentZoomFactor = newScale
//        }
//        
//        // ✅ 추가: onEnded에 호출하는 줌 기능
//        func zoomInitialize() {
//            lastScale = 1.0
//        }
    
    init() {
        Task {
            await handleCameraPreviews()
        }

        Task {
            await handleCameraPhotos()
        }
    }

    @MainActor
    func handleCameraPreviews() async {
        let imageStream = camera.previewStream
            .map { $0.image }

        for await image in imageStream {
            Task { @MainActor in
                viewfinderImage = image
            }
        }
    }

    func handleCameraPhotos() async {
        let unpackedPhotoStream = camera.photoStream
            .compactMap { self.unpackPhoto($0) }

        for await photoData in unpackedPhotoStream {
            Task { @MainActor in
                thumbnailImage = photoData.thumbnailImage
            }
            savePhoto(imageData: photoData.imageData)
        }
    }

    private func unpackPhoto(_ photo: AVCapturePhoto) -> PhotoData? {
        guard let imageData = photo.fileDataRepresentation() else { return nil }

        guard let previewCGImage = photo.previewCGImageRepresentation(),
              let metadataOrientation = photo.metadata[String(kCGImagePropertyOrientation)] as? UInt32,
              let cgImageOrientation = CGImagePropertyOrientation(rawValue: metadataOrientation) else { return nil }
        let imageOrientation = Image.Orientation(cgImageOrientation)
        let thumbnailImage = Image(decorative: previewCGImage, scale: 1, orientation: imageOrientation)

        let photoDimensions = photo.resolvedSettings.photoDimensions
        let imageSize = (width: Int(photoDimensions.width), height: Int(photoDimensions.height))
        let previewDimensions = photo.resolvedSettings.previewDimensions
        let thumbnailSize = (width: Int(previewDimensions.width), height: Int(previewDimensions.height))

        return PhotoData(thumbnailImage: thumbnailImage, thumbnailSize: thumbnailSize, imageData: imageData, imageSize: imageSize)
    }

    func savePhoto(imageData: Data) {
        Task {
//            do {
//                try await photoCollection.addImage(imageData)
                if let ciImage = CIImage(data: imageData) {
                    detect(image: ciImage) { [weak self] result in
                        self?.resultString = result
                    }
                }
                logger.debug("Added image data to photo collection.")
//            } catch let error {
//                logger.error("Failed to add image to photo collection: \(error.localizedDescription)")
//            }
        }
    }
}

fileprivate struct PhotoData {
    var thumbnailImage: Image
    var thumbnailSize: (width: Int, height: Int)
    var imageData: Data
    var imageSize: (width: Int, height: Int)
}

fileprivate extension CIImage {
    var image: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}

fileprivate extension Image.Orientation {

    init(_ cgImageOrientation: CGImagePropertyOrientation) {
        switch cgImageOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        }
    }
}

fileprivate let logger = Logger(subsystem: "com.apple.swiftplaygroundscontent.capturingphotos", category: "DataModel")

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
