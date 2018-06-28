# FIXME: testing fee calculator integration against local server
# client gem will default to
LAA::FeeCalculator.configure do |config|
  config.host = ENV['laa_fee_calculator_host']
end