////
////  CameraViewModel.swift
////  Nugunyang
////
////  Created by 원주연 on 6/17/24.
////

import AVFoundation
import SwiftUI
import Combine

class CameraViewModel: ObservableObject {
    private let model: Camera
    private let session: AVCaptureSession
    private var subscriptions = Set<AnyCancellable>()
    private var isCameraBusy = false
    
    let cameraPreview: AnyView
    let hapticImpact = UIImpactFeedbackGenerator()
    
    //줌 기능
    var currentZoomFactor: CGFloat = 1.0
    var lastScale: CGFloat = 1.0
    
    
    @Published var isFlashOn = false
    @Published var isSilentModeOn = false
    @Published var shutterEffect = false
    
    func configure() {
        model.requestAndCheckPermissions()
    }
    
    func switchFlash() {
        isFlashOn.toggle()
        model.flashMode = isFlashOn == true ? .on : .off
    }
    
//    func switchSilent() {
//        isSilentModeOn.toggle()
//        model.isSilentModeOn = isSilentModeOn
//    }
    
    func capturePhoto() {
        if isCameraBusy == false {
            hapticImpact.impactOccurred()
            withAnimation(.easeInOut(duration: 0.1)) {
                shutterEffect = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    self.shutterEffect = false
                }
            }
            
            model.catpurePhoto()
            print("[CameraViewModel]: Photo captured!")
        } else {
            print("[CameraViewModel]: Camera's busy.")
        }
    }
    
    // ✅ 추가: onChange에 호출하는 줌 기능
        func zoom(factor: CGFloat) {
            let delta = factor / lastScale
            lastScale = factor
            
            let newScale = min(max(currentZoomFactor * delta, 1), 5)
            model.zoom(newScale)
            currentZoomFactor = newScale
        }
        
        // ✅ 추가: onEnded에 호출하는 줌 기능
        func zoomInitialize() {
            lastScale = 1.0
        }
    
    func changeCamera() {
        print("[CameraViewModel]: Camera changed!")
    }
    
    init() {
        model = Camera()
        session = model.session
        cameraPreview = AnyView(CameraPreviewView(session: session))
        
        model.$isCameraBusy.sink { [weak self] (result) in
            self?.isCameraBusy = result
        }
        .store(in: &self.subscriptions)
    }
}
