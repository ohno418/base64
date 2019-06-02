TRANS_TABLE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

def encode(str)
  # ASCII 8bit に変換
  tmp = str.chars.map { |chr| chr.ord.to_s(2) }
  tmp = tmp.map { |b| '0'*(8-b.length) + b }.join(nil)

  # 6bit ずつに区切る
  tmp = (0..(tmp.length / 6)).map do |i|
    tmp[(6*i)..(6*(i+ 1)-1)]
  end

  # 最後の区切りを 6bit になるように 0 を追加
  tmp[-1] = tmp[-1] + '0'*(6-tmp[-1].length)

  # base64 変換規則にしたがって文字に変換
  tmp = tmp.map do |b|
    TRANS_TABLE[b.to_i(2)]
  end.join(nil)

  # 4文字ずつにわけたとき、不足分を "=" で補う
  tmp + '='*(tmp.length % 4)
end

# str="YWJjZGVmZw=="
def decode(str)
  # "=" をstrip
  tmp = str[0...str.index('=')]

  # base64 変換規則にしたがって 6bit 連続体に変換
  tmp = tmp.chars.map { |chr| TRANS_TABLE.index(chr).to_s(2) }
  tmp = tmp.map { |b| '0'*(6-b.length) + b }.join(nil)

  # 8bit 区切りにする
  tmp = (0..(tmp.length / 8)).map do |i|
    tmp[(8*i)..(8*(i+ 1)-1)]
  end

  unless tmp[-1].length == 8
    tmp = tmp[0..-2]
  end

  # ASCII 文字に変換
  tmp.map { |b| b.to_i(2).chr }.join(nil)
end
