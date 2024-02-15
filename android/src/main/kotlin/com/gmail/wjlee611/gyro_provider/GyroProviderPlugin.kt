package com.gmail.wjlee611.gyro_provider

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorManager

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel

/** GyroProviderPlugin */
class GyroProviderPlugin: FlutterPlugin {
  private lateinit var gyroEventChannel : EventChannel
  private lateinit var rotateEventChannel : EventChannel

  private lateinit var gyroStreamHandler : StreamHandlerImpl
  private lateinit var rotateStreamHandler : StreamHandlerImpl

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    setupEventChannel(flutterPluginBinding.applicationContext, flutterPluginBinding.binaryMessenger)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    teardownEventChannel()
  }

  private fun setupEventChannel(context: Context, messenger: BinaryMessenger) {
    val sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager

    // GYROSCOPE
    gyroEventChannel = EventChannel(messenger, "com.gmail.wjlee611.gyro_event_channel")
    gyroStreamHandler = StreamHandlerImpl(sensorManager, Sensor.TYPE_GYROSCOPE)
    gyroEventChannel.setStreamHandler(gyroStreamHandler)

    // ROTATION
    rotateEventChannel = EventChannel(messenger, "com.gmail.wjlee611.rotate_event_channel")
    rotateStreamHandler = StreamHandlerImpl(sensorManager, Sensor.TYPE_GAME_ROTATION_VECTOR)
    rotateEventChannel.setStreamHandler(rotateStreamHandler)
  }

  private fun teardownEventChannel() {
    gyroEventChannel.setStreamHandler(null)
    gyroStreamHandler.onCancel(null)

    rotateEventChannel.setStreamHandler(null)
    rotateStreamHandler.onCancel(null)
  }
}
