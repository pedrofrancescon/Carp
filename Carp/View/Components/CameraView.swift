//
//  CameraView.swift
//  Carp
//
//  Created by Eldade Marcelino on 26/11/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class CameraView: NSObject, UIComponentProtocol, AVCapturePhotoCaptureDelegate {

    let view: UIView = View.fix(View())
    private let captureSession = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var device: AVCaptureDeviceInput?
    private var captureCallback: ((_ image: CGImage) -> Void)?

    func setup() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video, position: .front
        ).devices.forEach { device in
            do {
                self.device = try AVCaptureDeviceInput(device: device)
            } catch {
                print(error)
            }
            guard let input = self.device else {
                return
            }
            captureSession.addInput(input)
            photoOutput.setPreparedPhotoSettingsArray(
                [AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])],
                completionHandler: nil
            )
            self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            guard let previewLayer = self.previewLayer else {
                return
            }
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.connection?.videoOrientation = .portrait
            previewLayer.frame = self.view.frame
            self.view.layer.insertSublayer(previewLayer, at: 0)
            captureSession.addOutput(photoOutput)
        }
        captureSession.startRunning()
    }

    func takePicture(_ callback: @escaping (_ image: CGImage) -> Void) {
        captureCallback = callback
        photoOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil {
            return
        }
        if let data = createMatchingBackingDataWithImage(
            imageRef: photo.cgImageRepresentation()?.takeUnretainedValue(),
            orienation: .leftMirrored) {
            captureCallback?(data)
            captureCallback = nil
        }
    }

    func stop() {
        captureSession.stopRunning()
    }

    func start() {
        captureSession.startRunning()
    }
}

// swiftlint:disable cyclomatic_complexity
// swiftlint:disable function_body_length
func createMatchingBackingDataWithImage(imageRef: CGImage?, orienation: UIImageOrientation) -> CGImage? {
    var orientedImage: CGImage?

    if let imageRef = imageRef {
        let originalWidth = imageRef.width
        let originalHeight = imageRef.height
        let bitsPerComponent = imageRef.bitsPerComponent
        let bytesPerRow = imageRef.bytesPerRow

        let bitmapInfo = imageRef.bitmapInfo

        guard let colorSpace = imageRef.colorSpace else {
            return nil
        }

        var degreesToRotate: Double
        var swapWidthHeight: Bool
        var mirrored: Bool
        switch orienation {
        case .up:
            degreesToRotate = 0.0
            swapWidthHeight = false
            mirrored = false
        case .upMirrored:
            degreesToRotate = 0.0
            swapWidthHeight = false
            mirrored = true
        case .right:
            degreesToRotate = 90.0
            swapWidthHeight = true
            mirrored = false
        case .rightMirrored:
            degreesToRotate = 90.0
            swapWidthHeight = true
            mirrored = true
        case .down:
            degreesToRotate = 180.0
            swapWidthHeight = false
            mirrored = false
        case .downMirrored:
            degreesToRotate = 180.0
            swapWidthHeight = false
            mirrored = true
        case .left:
            degreesToRotate = -90.0
            swapWidthHeight = true
            mirrored = false
        case .leftMirrored:
            degreesToRotate = -90.0
            swapWidthHeight = true
            mirrored = true
        }
        let radians = degreesToRotate * Double.pi / 180.0

        var width: Int
        var height: Int
        if swapWidthHeight {
            width = originalHeight
            height = originalWidth
        } else {
            width = originalWidth
            height = originalHeight
        }

        let contextRef = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        )
        contextRef?.translateBy(x: CGFloat(width) / 2.0, y: CGFloat(height) / 2.0)
        if mirrored {
            contextRef?.scaleBy(x: -1.0, y: 1.0)
        }
        contextRef?.rotate(by: CGFloat(radians))
        if swapWidthHeight {
            contextRef?.translateBy(x: -CGFloat(height) / 2.0, y: -CGFloat(width) / 2.0)
        } else {
            contextRef?.translateBy(x: -CGFloat(width) / 2.0, y: -CGFloat(height) / 2.0)
        }
        contextRef?.draw(
            imageRef,
            in: CGRect(x: 0.0, y: 0.0, width: CGFloat(originalWidth), height: CGFloat(originalHeight))
        )
        orientedImage = contextRef?.makeImage()
    }

    return orientedImage
}
