//
//  CameraView.swift
//  Nugunyang
//
//  Created by 원주연 on 6/17/24.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    @ObservedObject var viewModel = CameraViewModel()
    
    var body: some View {
        VStack {
            ZStack {
                viewModel.cameraPreview.ignoresSafeArea()
                    .onAppear {
                        viewModel.configure()
                    }
                    .gesture(MagnificationGesture()
                        .onChanged { val in
                            viewModel.zoom(factor: val)
                        }
                        .onEnded { _ in
                            viewModel.zoomInitialize()
                        })
                    .opacity(viewModel.shutterEffect ? 0 : 1)
                
                
                VStack{
                    Spacer().frame(height: 20)
                    
                    HStack {
                        // 플래시 온오프
                        Button(action: {viewModel.switchFlash()}) {
                            Image(systemName: viewModel.isFlashOn ?
                                  "bolt.fill" : "bolt")
                            .foregroundColor(viewModel.isFlashOn ? .yellow : .white)
                        }
                        .padding(.horizontal, 30)
                    }
                    .font(.system(size:25))
                    .padding().frame(height: 5)
                    
                    Spacer()
                }
                
            }
            
            Spacer()
            
            
            HStack{
                
                Spacer().frame(width: 150)
                
                // 사진찍기 버튼
                Button(action: {viewModel.capturePhoto()}) {
                    Circle()
//                        .stroke(lineWidth: 5)
                        .foregroundStyle(Color.secondary)
                        .frame(width: 80, height: 80)
                        .padding()
                        .overlay(
                            Circle()
                                .stroke(lineWidth: 2)
                                .frame(width: 45, height: 45)
                        )
                }
                
                Spacer()
                
                // 전후면 카메라 교체
                Button(action: {viewModel.changeCamera()}) {
                    Image(systemName: "arrow.triangle.2.circlepath.camera")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    
                }
                .frame(width: 75, height: 75)
                .padding()
            }
        }
        .background(Color.black)
        .foregroundColor(.white)
    }
}


struct CameraPreviewView: UIViewRepresentable {
    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }
        
        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }
    
    let session: AVCaptureSession
    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        
        view.backgroundColor = .black
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        view.videoPreviewLayer.cornerRadius = 0
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.connection?.videoOrientation = .portrait
        
        return view
    }
    
    func updateUIView(_ uiView: VideoPreviewView, context: Context) {
        
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
