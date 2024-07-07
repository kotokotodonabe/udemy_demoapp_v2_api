ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # プロセスが分岐した直後に呼び出し
  parallelize_setup do |worker|
    load "#{Rails.root}/db/seeds.rb"
  end

  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Add more helper methods to be used by all tests here...

  def active_user
    User.find_by(activated: true)
  end
end
