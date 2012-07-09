raw_config = File.read("#{Rails.root}/config/facebook_config.yml")
FACEBOOK_CONFIG = YAML.load(raw_config)[Rails.env].symbolize_keys
