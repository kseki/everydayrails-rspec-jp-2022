Rails.application.config do |config|
  config.generators do |g|
    g.test_framework :rspec,
                     fixtures: false,
                     view_specs: false,
                     helper_specs: false,
                     routing_specs: false
    g.factory_bot false
  end
end
