//
//  HandGestureViewModel.swift
//  CodCaptcha
//
//  Created by Jia Chen Yee on 20/1/24.
//

import CoreML
import Vision
import SwiftUI
import AVFoundation

class HandGestureViewModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private let rpsClassifier: RPS
    
    private let videoDataOutputQueue = DispatchQueue(label: "CameraFeedDataOutput", qos: .userInteractive)
    private var cameraFeedSession: AVCaptureSession?
    private var handPoseRequest = VNDetectHumanHandPoseRequest()
    
    @Published var predictionResult: ScissorsPaperStoneOption?
    @Published var errorMessage: String?
    
    override init() {
        do {
            rpsClassifier = try RPS(configuration: MLModelConfiguration())
            super.init()
            try setupAVSession()
        } catch {
            print(error.localizedDescription)
            fatalError("Failed to load MLModel")
        }
    }
    
    func setupAVSession() throws {
        // Select a front facing camera, make an input.
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            self.errorMessage = "Can't find the camera"
            return
        }
        
        guard let deviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            self.errorMessage = "Can't create video device input"
            return
        }
        
        let session = AVCaptureSession()
        session.beginConfiguration()
        session.sessionPreset = AVCaptureSession.Preset.high
        
        // Add a video input.
        guard session.canAddInput(deviceInput) else {
            self.errorMessage = "Can't add video device input to the session"
            return
        }
        session.addInput(deviceInput)
        
        let dataOutput = AVCaptureVideoDataOutput()
        if session.canAddOutput(dataOutput) {
            session.addOutput(dataOutput)
            // Add a video data output.
            dataOutput.alwaysDiscardsLateVideoFrames = true
            dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            self.errorMessage = "Can't add video data output to the session"
            return
        }
        session.commitConfiguration()
        session.startRunning()
        cameraFeedSession = session
    }
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up, options: [:])
        do {
            // Perform VNDetectHumanHandPoseRequest
            try handler.perform([handPoseRequest])
            // Continue only when a hand was detected in the frame.
            // Since we set the maximumHandCount property of the request to 1, there will be at most one observation.
            guard let observation = handPoseRequest.results?.first else {
                return
            }
            
            do {
                
                // Build input attributes from hand points and run prediction by custom mlmodel
                let output: RPSOutput = try rpsClassifier.prediction(poses: try observation.keypointsMultiArray())
                
                // Update predictionResult by output label
                DispatchQueue.main.async {
                    self.predictionResult = ScissorsPaperStoneOption(rawValue: output.label)
                }
            }
        } catch {
            cameraFeedSession?.stopRunning()
        }
    }
}

enum ScissorsPaperStoneOption: String, CaseIterable {
    case scissors = "scissors"
    case paper = "paper"
    case stone = "rock"
    
    var description: String {
        switch self {
        case .scissors:
            return "scissors".capitalized
        case .paper:
            return "paper".capitalized
        case .stone:
            return "stone".capitalized
        }
    }
    
    var losesTo: Self {
        switch self {
        case .scissors: return .stone
        case .paper: return .scissors
        case .stone: return .paper
        }
    }
    
    static func random() -> Self {
        .allCases.randomElement()!
    }
}
