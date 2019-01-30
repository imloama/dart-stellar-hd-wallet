import 'dart:convert';

import 'package:hex/hex.dart';
import 'package:pointycastle/digests/sha512.dart';
import 'package:pointycastle/export.dart';
import 'package:stellar/stellar.dart';
import 'package:bip39/bip39.dart' as bip39;
import "package:pointycastle/pointycastle.dart";
import 'dart:typed_data';

const ENTROPY_BITS = 256; // = 24 word mnemonic
const ENTROPY_BITS_HALF = 128; // = 12 word mnemonic

const INVALID_MNEMONIC = "Invalid mnemonic (see bip39)";

const KEY = "ed25519 seed";

/// stellar hd wallet
class StellarHDWallet{

  Uint8List _seed;

  StellarHDWallet._init(Uint8List seed){
    this._seed = seed;
  }

  /**
   * generate random mnemonic
   * @param {int} strength default 128, means generate 12 words
   * @param {string} language not working
   */
  static String generateMnemonic({int strength = ENTROPY_BITS_HALF, 
    language='english',  bip39.RandomBytes random}){
    return bip39.generateMnemonic(strength: strength, randomBytes: random);
  }

  /**
   * validate mnemonic
   */
  static bool validateMnemonic(String mnemonic,{language='english'}){
    return bip39.validateMnemonic(mnemonic);
  }

  static StellarHDWallet fromMnemonic(String mnemonic,{language='english'}){
    if(!validateMnemonic(mnemonic, language: language)){
      throw ArgumentError(INVALID_MNEMONIC);
    }
    return StellarHDWallet._init(bip39.mnemonicToSeed(mnemonic));
  }

  static StellarHDWallet fromSeed(Uint8List seed){
    return StellarHDWallet._init(seed);
  }

  static StellarHDWallet fromSeedHex(String seedHex){
    return StellarHDWallet._init(HEX.decode(seedHex));
  }


  Uint8List hMacSHA512(Uint8List key,Uint8List data){
    final _tmp = new HMac(new SHA512Digest(), 128)..init(new KeyParameter(key));
    return _tmp.process(data);
  }

  Uint8List derive(Uint8List seed, Uint8List chainCode, int index){
    var y = 2147483648 + index;
    Uint8List data = new Uint8List(37);
    data[0] = 0x00;
    data.setRange(1, 33, seed);
    data.buffer.asByteData().setUint32(33, y);
    var output = hMacSHA512(chainCode, data);
    return output;
  }



  /**
   * main code from BIP32
   */
  Uint8List derivePath(String path){
    final regex = new RegExp(r"^(m\/)?(\d+'?\/)*\d+'?$");
    if (!regex.hasMatch(path)) throw new ArgumentError("Expected BIP32 Path");
    List<String> splitPath = path.split("/");
    if (splitPath[0] == "m") {
      splitPath = splitPath.sublist(1);
    }
    final seed = hMacSHA512(utf8.encode(KEY), this._seed);
    Uint8List result = splitPath.fold(seed, ( Uint8List prev,String indexStr) {
      int index;
      if (indexStr.substring(indexStr.length - 1) == "'") {
        index = int.parse(indexStr.substring(0, indexStr.length - 1));
      } else {
        index = int.parse(indexStr);
      }
      return derive(prev.sublist(0,32), prev.sublist(32), index);
    });
    return result;
  }

  KeyPair getKeyPair({int index = 0}) {
    final key = this.derivePath("m/44'/148'/$index'");
    return KeyPair.fromSecretSeedList(key.sublist(0,32));
  }

  String getAccountId({int index = 0}){
    return this.getKeyPair(index: index).accountId;
  }

  String getSecretSeed({int index = 0}){
    return this.getKeyPair(index:index).secretSeed;
  }

  Uint8List get seed => this._seed;

}