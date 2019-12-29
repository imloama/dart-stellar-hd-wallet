import 'package:test/test.dart';
import 'package:stellar_hd_wallet/stellar_hd_wallet.dart';

import 'package:stringprocess/stringprocess.dart';

void main() {
  StringProcessor tps = new StringProcessor();

  test('get account id from mnemonic', () {
    final mnemonic =
        "illness spike retreat truth genius clock brain pass fit cave bargain toe";
    final wallet = StellarHDWallet.fromMnemonic(mnemonic);
    final keypair = wallet.getKeyPair();
    expect(keypair.accountId,
        "GDRXE2BQUC3AZNPVFSCEZ76NJ3WWL25FYFK6RGZGIEKWE4SOOHSUJUJ6");
    expect(wallet.getSecretSeed(),
        "SBGWSG6BTNCKCOB3DIFBGCVMUPQFYPA2G4O34RMTB343OYPXU5DJDVMN");
    expect(wallet.getAccountId(index: 1),
        "GBAW5XGWORWVFE2XTJYDTLDHXTY2Q2MO73HYCGB3XMFMQ562Q2W2GJQX");
    expect(wallet.getSecretSeed(index: 1),
        "SCEPFFWGAG5P2VX5DHIYK3XEMZYLTYWIPWYEKXFHSK25RVMIUNJ7CTIS");
  });

  test('generate twelve word mnemonic and create wallet', () {
    final generatedTwelveWordMnemonic = StellarHDWallet.generateMnemonic();
    final wallet = StellarHDWallet.fromMnemonic(generatedTwelveWordMnemonic);
    final keypair = wallet.getKeyPair();

    expect(tps.getWordCount(generatedTwelveWordMnemonic), 12);
    expect(keypair.accountId.length, 56);
  });

  test('generate twenty-four word mnemonic and create wallet', () {
    final generatedTwenty_fourWordMnemonic = StellarHDWallet.generateMnemonic(strength: ENTROPY_BITS);
    final wallet = StellarHDWallet.fromMnemonic(generatedTwenty_fourWordMnemonic);
    final keypair = wallet.getKeyPair();

    expect(tps.getWordCount(generatedTwenty_fourWordMnemonic), 24);
    expect(keypair.accountId.length, 56);
  });
}
