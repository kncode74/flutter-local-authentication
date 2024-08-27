import 'dart:convert';

import 'package:biometric_storage/biometric_storage.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pinenacl/ed25519.dart';
import 'package:pinenacl/tweetnacl.dart';

class SecureKey {
  String state = 'N/A';
  BiometricStorageFile? sharedKeyStorage;
  String? saveSeed;
  String? saveSharedKey;

  Future<bool> canAuthentication() async {
    final auth = LocalAuthentication();
    bool canAuthenticationWithBiometric = await auth.canCheckBiometrics;
    bool canAuthenticate =
        canAuthenticationWithBiometric || await auth.isDeviceSupported();
    return canAuthenticate;
  }

  Future<void> _saveKey(String sharedKey, String seed) async {
    // Save both key to biometric storage
    print("flutter_biometric: saved key succeed $sharedKey, seed: $seed");
    try {
      sharedKeyStorage = await BiometricStorage().getStorage('sharedKey',
          options: StorageFileInitOptions(authenticationRequired: true));
      await sharedKeyStorage!.write('$sharedKey:$seed');
    } on PlatformException catch (e) {
      print("flutter_biometric: saved key failed $e");
    }

    // setState(() {
    //   state = 'saved key succeed';
    // });
  }

  Future<String> createShareKey(
      KeyPair keypair, String serverSidePublicKey) async {
    final serverPublicKey = SimplePublicKey(base64.decode(serverSidePublicKey),
        type: KeyPairType.x25519);

    final sharedKey = await X25519().sharedSecretKey(
      keyPair: keypair,
      remotePublicKey: serverPublicKey,
    );
    final sharedKeyAsBytes = await sharedKey.extractBytes();
    return base64.encode(sharedKeyAsBytes);
  }

  Future<void> requestToBiometricLogin() async {
    bool canAuth = await canAuthentication();

    if (canAuth) {
      bool authenticated = await LocalAuthentication().authenticate(
        localizedReason: 'Please authenticate to access your bank account',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
      if (authenticated) {
        print("flutter_biometric: authenticated succeed");
        // Step1: create private key from client
        final keypair = await X25519().newKeyPair();
        final seedForBiometric = TweetNaCl.randombytes(TweetNaCl.seedSize);

        // Step2: create public key from client and verify key
        final publicKey = await keypair.extractPublicKey();
        final clientPublicKey = base64.encode(publicKey.bytes);

        final signingKey = SigningKey(seed: seedForBiometric);
        final verifyBiometircKey = base64.encode(signingKey.verifyKey);

        // Step3: send clientPublicKey and verifyBiometircKey to server and get serverKey back
        final serverKey = 'serverKey';
        // _submitKeyToServer(clientPublicKey, verifyBiometircKey);

        // Step4: create shared key from client and server
        final sharedKey = await createShareKey(keypair, serverKey);

        // Step5: save sharedKey to biometric storage
        await _saveKey(sharedKey, base64.encode(seedForBiometric));
      }
    }
  }
}
