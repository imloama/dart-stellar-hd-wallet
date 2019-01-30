# stellar_hd_wallet

Stellar HD Wallet

## import

pubspec.yaml
```
stellar_hd_wallet: ^0.0.1
```

## generate mnemonic
```
import "stellar_hd_wallet/wallet.dart";

final mnemonic = StellarHDWallet.generateMnemonic();

```

## get keypair from mnemonic
```
import "stellar_hd_wallet/wallet.dart";

final keypair = StellarHDWallet.fromMnemonic(mnemonic);
final accountId = keypair.accountId;
final secretSeed = keypair.secretSeed;

```

