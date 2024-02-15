import Flutter

var _eventChannels: [String: FlutterEventChannel] = [:]
var _streamHandlers: [String: FlutterStreamHandler] = [:]
var _isCleanUp = false

public class GyroProviderPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let gyroStreamHandler = GyroStreamHandler()
        let gyro = "com.gmail.wjlee611.gyro_event_channel"
        let gyroEventChannel = FlutterEventChannel(
            name: gyro,
            binaryMessenger: registrar.messenger()
        )
        gyroEventChannel.setStreamHandler(gyroStreamHandler)
        _eventChannels[gyro] = gyroEventChannel
        _streamHandlers[gyro] = gyroStreamHandler
        
        
        let rotateStreamHandler = RotateStreamHandler()
        let rotate = "com.gmail.wjlee611.rotate_event_channel"
        let rotateEventChannel = FlutterEventChannel(
            name: rotate,
            binaryMessenger: registrar.messenger()
        )
        rotateEventChannel.setStreamHandler(rotateStreamHandler)
        _eventChannels[rotate] = rotateEventChannel
        _streamHandlers[rotate] = rotateStreamHandler
        
        
        _isCleanUp = false
    }

    static func _cleanUp() {
        _isCleanUp = true
        for channel in _eventChannels.values {
            channel.setStreamHandler(nil)
        }
        _eventChannels.removeAll()
        for handler in _streamHandlers.values {
            handler.onCancel(withArguments: nil)
        }
        _streamHandlers.removeAll()
    }
}
