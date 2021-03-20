//
//  camera.swift
//  Yelm.ProjectX
//
//  Created by Michael on 14.01.2021.
//

import Foundation
import SwiftUI
import AVFoundation
import Yelm_Chat

struct CustomCameraView: View {
    
    @State var image: UIImage?
    @State var capture: Bool = false
    

    
    var body: some View {
        #if targetEnvironment(simulator)
        VStack{
            Text("S")
        }
        #else
            CustomCameraRepresentable(image: self.$image, didTapCapture: $capture)
        #endif

    }
    
}


struct CustomCameraRepresentable: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    @Binding var didTapCapture: Bool
    
    

    func makeUIViewController(context: Context) -> CustomCameraController {
        let controller = CustomCameraController()
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ cameraViewController: CustomCameraController, context: Context) {
        
        if(self.didTapCapture) {
            cameraViewController.didTapRecord()
        }
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate {
        let parent: CustomCameraRepresentable
        
        @ObservedObject var camera : camera = GlobalCamera
        @ObservedObject var chat: ChatIO = YelmChat
        @ObservedObject var modal : ModalManager = GlobalModular
        
        init(_ parent: CustomCameraRepresentable) {
            self.parent = parent
        }
        
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            
            parent.didTapCapture = false
            self.camera.objectWillChange.send()
            self.camera.open = true
            
            if let imageData = photo.fileDataRepresentation() {
                parent.image = UIImage(data: imageData)
                
                UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData)!, nil, nil, nil)

                
                let base64 : String = UIImage(data: imageData)!.jpegData(compressionQuality: 0.5)?.base64EncodedString() ?? ""
                self.chat.core.send(message: base64, type: "images")
                
                self.modal.objectWillChange.send()
                self.modal.closeModal()
                
                
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}



class CustomCameraController: UIViewController {
    
    var image: UIImage?
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    //DELEGATE
    var delegate: AVCapturePhotoCaptureDelegate?
    
    func didTapRecord() {
        
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: delegate!)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    func setup() {
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
    }
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera],
                                                                      mediaType: AVMediaType.video,
                                                                      position: AVCaptureDevice.Position.unspecified)
        for device in deviceDiscoverySession.devices {
            
            switch device.position {
            case AVCaptureDevice.Position.front:
                self.frontCamera = device
            case AVCaptureDevice.Position.back:
                self.backCamera = device
            default:
                break
            }
        }
        
        self.currentCamera = self.backCamera
    }
    
    
    func setupInputOutput() {
        do {
            
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
            
        } catch {
            print(error)
        }
        
    }
    func setupPreviewLayer()
    {
        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        self.cameraPreviewLayer?.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        
    }
    func startRunningCaptureSession(){
        captureSession.startRunning()
    }
}




struct CustomCameraViewFull: View {
    
    @State var image: UIImage?
    @State var capture: Bool = false

    @ObservedObject var camera : camera = GlobalCamera
    @ObservedObject var chat: ChatIO = YelmChat
    @ObservedObject var modal : ModalManager = GlobalModular
    
    var body: some View {
        #if targetEnvironment(simulator)
        VStack{
            Text("S")
        }
        #else
        
        Rectangle()
            .fill(Color.clear)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/1.3)
            .overlay(
                
                ZStack(alignment: .top){
                    
                ZStack(alignment: .bottom){
                    CustomCameraRepresentableFull(image: self.$image, didTapCapture: $capture)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/1.3)
                    
                    Button(action: {
                        
                        print("capture image start")
                        self.capture = true
                        
                    }) {
                        VStack{
                            ZStack{
                                Circle()
                                    .fill(Color.theme)
                                    .frame(width: 80, height: 80)
                                
                                
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 70, height: 70)
                                
                                
                                Circle()
                                    .fill(Color.theme)
                                    .frame(width: 40, height: 40)
                            }
                        }
                        .padding(.bottom, 50)
                    }.buttonStyle(ScaleButtonStyle())
                    
                    
                }
                    
                    HStack{
                        HStack{
                           
                            
                            Spacer()
                            
                            
                            Button(action: {
                                
                                
                                self.camera.open = false
                                
                                
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(Color.theme_foreground)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                
                            }.buttonStyle(ScaleButtonStyle())

                            
                          
                                
                            
                        }
                        .padding(.horizontal, 30)
                        .padding(.top, 8)
                        
                    }
                   
                    .frame(width: UIScreen.main.bounds.width, height: 50)
                    .background(Color.black.opacity(0.3))
                    
                }
            )
        
     
        #endif

    }
    
}


struct CustomCameraRepresentableFull: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    @Binding var didTapCapture: Bool
    
    func makeUIViewController(context: Context) -> CustomCameraControllerFull {
        let controller = CustomCameraControllerFull()
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ cameraViewController: CustomCameraControllerFull, context: Context) {
        
        if(self.didTapCapture) {
            print("capture image updateUIViewController")
            cameraViewController.didTapRecord()
        }
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate {
        let parent: CustomCameraRepresentableFull
        
        
        @ObservedObject var camera : camera = GlobalCamera
        @ObservedObject var chat: ChatIO = YelmChat
        @ObservedObject var modal : ModalManager = GlobalModular
        
        func fixOrientationOfImage(image: UIImage) -> UIImage? {
            if image.imageOrientation == .up {
                return image
            }

            // We need to calculate the proper transformation to make the image upright.
            // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
            var transform = CGAffineTransform.identity

            switch image.imageOrientation {
               case .down, .downMirrored:
                transform = transform.translatedBy(x: image.size.width, y: image.size.height)
                transform = transform.rotated(by: CGFloat(Double.pi))
            case .left, .leftMirrored:
                transform = transform.translatedBy(x: image.size.width, y: 0)
                transform = transform.rotated(by:  CGFloat(Double.pi / 2))
            case .right, .rightMirrored:
                transform = transform.translatedBy(x: 0, y: image.size.height)
                transform = transform.rotated(by:  -CGFloat(Double.pi / 2))
            default:
                break
            }

            switch image.imageOrientation {
            case .upMirrored, .downMirrored:
                transform = transform.translatedBy(x: image.size.width, y: 0)
                transform = transform.scaledBy(x: -1, y: 1)
            case .leftMirrored, .rightMirrored:
                transform = transform.translatedBy(x: image.size.height, y: 0)
                transform = transform.scaledBy(x: -1, y: 1)
            default:
                break
            }
            
            guard let context = CGContext(data: nil, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: image.cgImage!.bitsPerComponent, bytesPerRow: 0, space: image.cgImage!.colorSpace!, bitmapInfo: image.cgImage!.bitmapInfo.rawValue) else {
                  return nil
              }

              context.concatenate(transform)

              switch image.imageOrientation {
                case .left, .leftMirrored, .right, .rightMirrored:
                  context.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: image.size.height, height: image.size.width))
                 default:
                    context.draw(image.cgImage!, in: CGRect(origin: .zero, size: image.size))
              }

              // And now we just create a new UIImage from the drawing context
              guard let CGImage = context.makeImage() else {
                  return nil
              }

              return UIImage(cgImage: CGImage)
        }
        
        init(_ parent: CustomCameraRepresentableFull) {
            self.parent = parent
        }
        
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            
            
            print("capture image photoOutput")
            
            parent.didTapCapture = false
            self.camera.objectWillChange.send()
            self.camera.open = true
            
            if let imageData = photo.fileDataRepresentation() {
                parent.image = self.fixOrientationOfImage(image: UIImage(data: imageData)!)
                
                print("capture image fileDataRepresentation")
                
                let base64 : String = UIImage(data: imageData)!.jpegData(compressionQuality: 0.5)?.base64EncodedString() ?? ""
                self.chat.core.send(message: base64, type: "images")
                
                self.modal.objectWillChange.send()
                self.modal.closeModal()
                
                
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}



class CustomCameraControllerFull: UIViewController {
    
    var image: UIImage?
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    //DELEGATE
    var delegate: AVCapturePhotoCaptureDelegate?
    
    func didTapRecord() {
        
        let settings = AVCapturePhotoSettings()
        
        photoOutput?.capturePhoto(with: settings, delegate: delegate!)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    func setup() {
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
    }
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera],
                                                                      mediaType: AVMediaType.video,
                                                                      position: AVCaptureDevice.Position.unspecified)
        for device in deviceDiscoverySession.devices {
            
            switch device.position {
            case AVCaptureDevice.Position.front:
                self.frontCamera = device
            case AVCaptureDevice.Position.back:
                self.backCamera = device
            default:
                break
            }
        }
        
        self.currentCamera = self.backCamera
    }
    
    
    func setupInputOutput() {
        do {
            
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
            
        } catch {
            print(error)
        }
        
    }
    func setupPreviewLayer()
    {
        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        self.cameraPreviewLayer?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        
    }
    func startRunningCaptureSession(){
        captureSession.startRunning()
    }
}

