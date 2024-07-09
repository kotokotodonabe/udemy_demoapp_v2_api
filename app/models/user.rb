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

  # 共通のJONレスポンス
  def response_json(payload = {})
    as_json(only: [:id, :name]).merge(payload).with_indifferent_access
  end
end
