# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'simplecov'
SimpleCov.start
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your∏
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

    config.before(:suite) do
    DatabaseCleaner[:active_record].strategy = :truncation
      merchants = []
      20.times do merchants << Merchant.create!(name: Faker::Company.name)
      end
      merchant_ids = merchants.map{|merchant| merchant.id }
      merchants.each do |merchant|
        10.times{ merchant.items.create!( name: Faker::Commerce.product_name, description: Faker::Lorem.sentence, unit_price: Faker::Commerce.price )}
      end
      customers = []
      20.times { customers << Customer.create!(first_name: Faker::Games::StreetFighter.character, last_name: Faker::Games::ElderScrolls.last_name)}
      customer_ids = customers.map { |customer| customer.id}
      invoices = []
      20.times { invoices << Invoice.create!(customer_id: customer_ids.sample, merchant_id: merchant_ids.sample, status: ['shipped', 'pending', 'cancelled'].sample)}
      invoices.each do |invoice|
        10.times{ invoice.transactions.create!(credit_card_number: Faker::Business.credit_card_number, credit_card_expiration_date: Faker::Business.credit_card_expiry_date, result: ['success', 'failed'].sample)}
      end
      invoice_ids = invoices.map { |invoice| invoice.id }
      item_ids = merchants.map {|merchant| merchant.items.map{|item| item.id}}.flatten!
      invoice_items = []
      20.times { invoice_items << InvoiceItem.create!(item_id: item_ids.sample, invoice_id: invoice_ids.sample, quantity: Faker::Number.within(range: 2..20), unit_price: Faker::Commerce.price )}
  end

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
  config.include FactoryBot::Syntax::Methods
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
