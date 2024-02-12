package com.gmail.wjlee611.gyro_provider

import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.StreamHandler

internal class StreamHandlerImpl (
    private val sensorManager: SensorManager,
    private val type : Int
) : StreamHandler {
    private var sensor : Sensor? = null
    private var sensorEventListener: SensorEventListener? = null
    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        sensor = sensorManager.getDefaultSensor(type)
        if (sensor != null) {
            sensorEventListener = getGyroSensorEventListener(events)
            sensorManager.registerListener(
                sensorEventListener,
                sensor,
                SensorManager.SENSOR_DELAY_NORMAL
            )
        } else {
            events.error(
                "NO_${getSensorString(type).uppercase()}_SENSOR",
                "${getSensorString(type)} sensor not found",
                "${getSensorString(type)} sensor not found"
            )
        }
    }

    override fun onCancel(arguments: Any?) {
        sensorManager.unregisterListener(sensorEventListener)
        sensorEventListener = null
    }

    private fun getGyroSensorEventListener(events : EventChannel.EventSink) : SensorEventListener {
        return object : SensorEventListener {
            override fun onAccuracyChanged(sensor: Sensor, accuracy: Int) {}

            override fun onSensorChanged(event: SensorEvent) {
                val sensorValues = DoubleArray(event.values.size)
                event.values.forEachIndexed { index, value ->
                    sensorValues[index] = value.toDouble()
                }
                events.success(sensorValues)
            }
        }
    }

    private fun getSensorString(type: Int) : String {
        if (type == Sensor.TYPE_GYROSCOPE) {
            return "GYROSCOPE"
        }
        else if (type == Sensor.TYPE_GAME_ROTATION_VECTOR) {
            return "ROTATION"
        }
        return "null"
    }
}