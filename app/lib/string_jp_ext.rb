require 'nkf'

module StringJpExt

  refine String do

    def to_hiragana
      NKF.nkf '-W -w -X -m0 -Z1 --hiragana', self
      # -W   入力に UTF-8 を仮定する
      # -w   UTF-8 を出力する(BOMなし)
      # -X   X0201片仮名(いわゆる半角片仮名)をX0208の片仮名(いわゆる全角片仮名)に変換する
      # -m0  MIME の解読を一切しない。エンコーディングの変換のみをするならばこれを指定しておくべきである
      # -Z1  X0208空白(いわゆる全角空白)を ASCII の空白に変換する
      # --hiragana  片仮名を平仮名に変換する
    end
  end
end
