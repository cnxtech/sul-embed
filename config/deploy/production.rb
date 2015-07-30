set :home_directory, "/opt/app/#{fetch(:user)}"
set :deploy_to, "#{fetch(:home_directory)}/#{fetch(:application)}"

set :bundle_without, %w{development test}.join(' ')

set :rails_env, 'production'
