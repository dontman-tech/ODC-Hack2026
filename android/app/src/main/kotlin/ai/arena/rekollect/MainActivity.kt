package ai.arena.rekollect

import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "rekollect/dialer").setMethodCallHandler { call, result ->
            if (call.method == "openDialer") {
                val phoneNumber = call.arguments as? String
                if (phoneNumber.isNullOrBlank()) {
                    result.error("INVALID_PHONE", "Phone number is empty", null)
                    return@setMethodCallHandler
                }
                val intent = Intent(Intent.ACTION_DIAL, Uri.parse("tel:$phoneNumber"))
                startActivity(intent)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }
}
