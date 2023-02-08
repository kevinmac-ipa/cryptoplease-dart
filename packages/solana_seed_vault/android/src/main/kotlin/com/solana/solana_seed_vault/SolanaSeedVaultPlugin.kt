package com.solana.solana_seed_vault

import androidx.annotation.NonNull
import com.solana.solana_seed_vault.utils.PermissionHandler
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding


/** SolanaSeedVaultPlugin */
class SolanaSeedVaultPlugin : FlutterPlugin, ActivityAware {
    private lateinit var walletApiHost: WalletApiHost;
    private lateinit var permissionHandler: PermissionHandler;

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val context = flutterPluginBinding.applicationContext
        val messenger = flutterPluginBinding.binaryMessenger
        val changeNotifier = ChangeNotifier(messenger)

        permissionHandler =
            PermissionHandler { changeNotifier.observeSeedVaultContentChanges(context) }

        walletApiHost = WalletApiHost(context, permissionHandler)
        walletApiHost.init(messenger)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        walletApiHost.setActivity(binding)
        permissionHandler.setActivity(binding)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        walletApiHost.setActivity(binding)
        permissionHandler.setActivity(binding)
    }

    override fun onDetachedFromActivity() = Unit

    override fun onDetachedFromActivityForConfigChanges() = Unit

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) = Unit
}
