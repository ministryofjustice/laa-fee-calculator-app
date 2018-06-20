# FIXME: testing fee calculator integration against local server
LAA::FeeCalculator.configure do |config|
  config.host = 'http://localhost:8000/api/v1'
end