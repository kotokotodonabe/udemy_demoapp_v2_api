ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"
# minitest-reportersを使用するための設定
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # プロセスが分岐した直後に呼び出し
  parallelize_setup do |worker|
    load "#{Rails.root}/db/seeds.rb"
  end

  # 並列テストの有効か・無効化の設定
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
