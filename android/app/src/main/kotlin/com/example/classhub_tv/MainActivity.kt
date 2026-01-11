package com.example.classhub_tv

import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

class MainActivity: FlutterActivity() {
    private val CHANNEL = "classhub/system_apps"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getInstalledApps" -> {
                    val apps = getInstalledApps()
                    result.success(apps)
                }
                "launchApp" -> {
                    val packageName = call.argument<String>("packageName")
                    if (packageName != null) {
                        launchApp(packageName)
                        result.success(true)
                    } else {
                        result.error("INVALID_ARGUMENT", "Package name is null", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun getInstalledApps(): List<Map<String, Any>> {
        val apps = mutableListOf<Map<String, Any>>()
        val packageManager = context.packageManager
        
        // Get ALL installed packages (including system apps)
        val allPackages = packageManager.getInstalledPackages(0)

        for (packageInfo in allPackages) {
            val packageName = packageInfo.packageName

            // Skip own app
            if (packageName == context.packageName) continue

            // Check if it's launchable
            val isStandardLaunchable = packageManager.getLaunchIntentForPackage(packageName) != null
            var isLeanbackLaunchable = false
            
            if (!isStandardLaunchable) {
                 val leanbackIntent = Intent(Intent.ACTION_MAIN)
                 leanbackIntent.addCategory(Intent.CATEGORY_LEANBACK_LAUNCHER)
                 leanbackIntent.setPackage(packageName)
                 if (packageManager.queryIntentActivities(leanbackIntent, 0).isNotEmpty()) {
                     isLeanbackLaunchable = true
                 }
            }

            if (isStandardLaunchable || isLeanbackLaunchable) {
                // It is an app (User or System) that can be launched
                val applicationInfo = packageInfo.applicationInfo
                
                if (applicationInfo != null) {
                    val appName = packageManager.getApplicationLabel(applicationInfo).toString()
                    val icon = packageManager.getApplicationIcon(applicationInfo)
                    val iconBytes = drawableToByteArray(icon)
    
                    apps.add(mapOf(
                        "packageName" to packageName,
                        "appName" to appName,
                        "iconBytes" to iconBytes
                    ))
                }
            }
        }
        
        // Sort by name for convenience? Or let Flutter handle it.
        // Let's keep it unsorted or simple add order.
        return apps
    }

    private fun launchApp(packageName: String) {
        val launchIntent = context.packageManager.getLaunchIntentForPackage(packageName)
        if (launchIntent != null) {
            startActivity(launchIntent)
        }
    }

    private fun drawableToByteArray(drawable: Drawable): ByteArray {
        val bitmap = if (drawable is BitmapDrawable) {
            drawable.bitmap
        } else {
            val width = if (drawable.intrinsicWidth > 0) drawable.intrinsicWidth else 1
            val height = if (drawable.intrinsicHeight > 0) drawable.intrinsicHeight else 1
            val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
            val canvas = Canvas(bitmap)
            drawable.setBounds(0, 0, canvas.width, canvas.height)
            drawable.draw(canvas)
            bitmap
        }

        val stream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
        return stream.toByteArray()
    }
}
