class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # 文字数の制限
    max = 255
    record.errors.add(attribute, :too_long, count: max) if value.length > max

    # emailの形式
    format = /\A\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*\z/
    record.errors.add(attribute, :invalid) unless format =~ value

    # emailの一意性
    record.errors.add(attribute, :taken) if record.email_activated?
  end
end
