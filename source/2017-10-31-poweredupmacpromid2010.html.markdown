---
title: ぼくが かんがえた さいきょう Mac Pro (Mid 2010)
---
# ぼくが かんがえた さいきょう Mac Pro (Mid 2010)

Mac Pro (Mid 2010) に次の装備をしました。

* メモリ 4GB (x4) 合計 16GB
* ZOTAC NVIDIA GeForce GTX680
* Allegro Pro USB3.0 PCIe
* Tempo SSD Pro Plus (x2)
* Crucial MX300 525GB (x4)
* Seagate IronWolf 10TB

## セットアップのしかた

組み上げる順番が大事です。

1. メモリと Seagate IronWolf 10TB を装着し，2基の Tempo SSD Pro Plus ＋ Crucial MX300 (x2) をスロット3,4に装着する。 **ビデオカードは元のまま**
2. 起動して Disk Utility で RAID にしてフォーマットする
3. 再起動して ⌘+R を押してリカバリーモードに入り，OS をインストールする
4. 再起動して正常に起動することを確認する
5. 電源を落とす
6. ZOTAC NVIDIA GeForce GTX680 をスロット1に装着する
7. 起動してしばらく待ち，画面が正常に表示されることを確認する
8. 電源を落とす
9. Allegro Pro USB3.0 PCIe をスロット2に装着する
10. 起動してデバイスドライバーをインストールする

SSD をフォーマットするより前に ZOTAC NVIDIA GeForce GTX680 を装着すると，SSD を装着した後に起動した際に画面が表示されません。

## SSD(x4) RAID0 の威力

Blackmagic Design Disk Speed Test version 3.1 で計測しました。

### 装着前

Mac Pro (Mid 2010) + HDD

* Write 85.4MB/s
* Read 95.5MB/s

### 装着後

Mac Pro (Mid 2010) + Crucial MX300 x 4 RAID0

* Write  1085.5MB/s
* Read  1106.9MB/s

### 参考記録

新型 Mac Pro (2013)

* Write 761.8MB/s
* Read 939.9MB/s

だそうです。新型 Mac Pro より速い！

## NVIDIA GeForce GTX680 の威力

4K 出力が可能らしいです。

でも目当てとしては 4K ではなく，Tensor Flow を走らせたかったので，NVIDIA 製のビデオカードにしたかったのです。

