if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      provider:              'AWS',                        # required
      aws_access_key_id:     Rails.application.credentials.dig(:aws, :access_key_id),                        # required unless using use_iam_profile
      aws_secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key),                        # required unless using use_iam_profile
      use_iam_profile:       false,                         # optional, defaults to false
      region:                'sa-east-1',                  # optional, defaults to 'us-east-1'
    }
    config.fog_directory  = Rails.application.credentials.dig(:aws, :bucket)                                      # required
    config.fog_public     = false                                                 # optional, defaults to true
  end
end
