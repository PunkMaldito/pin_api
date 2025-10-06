source "https://rubygems.org"

gem "rails", "~> 8.0.3"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false
gem "jwt"
gem "pundit"
gem "bcrypt"
gem "rack-cors"
gem "jsonapi-serializer"

group :development, :test do
    gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
    gem "brakeman", require: false
    gem "rubocop-rails-omakase", require: false
    gem "rspec-rails", "~> 7.0"
    gem "factory_bot_rails", "~> 6.4"
    gem "faker", "~> 3.5"
end

group :test do
  gem "shoulda-matchers", "~> 6.0"
  gem "database_cleaner-active_record", "~> 2.1"
end
