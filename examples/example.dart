import 'package:stellar_hd_wallet/wallet.dart';

void main(){
        // get random mnemonic ( english )
        final mnemonic = StellarHDWallet.generateMnemonic();
        print(mnemonic);
        final wallet = StellarHDWallet.fromMnemonic(mnemonic);
        final keypair = wallet.getKeyPair();
        // get accountId
        final accountId = keypair.accountId;
        final secretSeed = keypair.secretSeed;
        print(accountId);
        print(secretSeed);
        final keypairIndex1 = wallet.getKeyPair(index: 1);
        print(keypairIndex1.accountId);
        print(keypairIndex1.secretSeed);

    }