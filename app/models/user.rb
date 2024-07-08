class User < ApplicationRecord
  # token生成モジュール
  include TokenGenerateService
  has_secure_password

  # リフレっしょトークンのJWT IDを記憶する
  def remember(jti)
    update!(refresh_jti: jti)
  end

  def forget
    update!(refresh_jti: nil)
  end
end
