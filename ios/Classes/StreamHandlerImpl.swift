import Foundation
import Flutter
import UIKit
import CoreMotion

var _motionManager: CMMotionManager!

func _initMotionManager() {
    if (_motionManager == nil) {
        _motionManager = CMMotionManager()
        _motionManager.accelerometerUpdateInterval = 0.1
        _motionManager.deviceMotionUpdateInterval = 0.1
        _motionManager.gyroUpdateInterval = 0.1
        _motionManager.magnetometerUpdateInterval = 0.1
    }
}

func sendVector3(x: Float64, y: Float64, z: Float64, events: @escaping FlutterEventSink) {
    if _isCleanUp {
        return
    }
    DispatchQueue.main.async {
        let vector = [x, y, z]
        vector.withUnsafeBufferPointer { buffer in
            events(FlutterStandardTypedData.init(float64: Data(buffer: buffer)))
        }
    }
}

class GyroStreamHandler: NSObject, FlutterStreamHandler {
    func onListen(
        withArguments arguments: Any?,
        eventSink events: @escaping FlutterEventSink
    ) -> FlutterError? {
        _initMotionManager();
        _motionManager.startGyroUpdates(to: OperationQueue()) { data, error in
            if _isCleanUp {
                return
            }
            if (error != nil) {
                events(FlutterError(
                    code: "NO_GYROSCOPE_SENSOR",
                    message: error!.localizedDescription,
                    details: nil
                ))
                return
            }
            let rotationRate = data!.rotationRate
            sendVector3(x: rotationRate.x, y: rotationRate.y, z: rotationRate.z, events: events)
        }
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        _motionManager.stopGyroUpdates()
        return nil
    }
    
    func dealloc() {
        GyroProviderPlugin._cleanUp()
    }
}

class RotateStreamHandler: NSObject, FlutterStreamHandler {
    func onListen(
        withArguments arguments: Any?,
        eventSink events: @escaping FlutterEventSink
    ) -> FlutterError? {
        _initMotionManager();
        _motionManager.startDeviceMotionUpdates(to: OperationQueue()) { data, error in
            if _isCleanUp {
                return
            }
            if (error != nil) {
                events(FlutterError(
                    code: "NO_ROTATION_SENSOR",
                    message: error!.localizedDescription,
                    details: nil
                ))
                return
            }
            let rotationRate = data!.rotationRate
            sendVector3(x: rotationRate.x, y: rotationRate.y, z: rotationRate.z, events: events)
        }
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        _motionManager.stopDeviceMotionUpdates()
        return nil
    }
    
    func dealloc() {
        GyroProviderPlugin._cleanUp()
    }
}
