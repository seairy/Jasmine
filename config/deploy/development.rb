# -*- encoding : utf-8 -*-
set :stage, :production
set :branch, 'master'
set :rvm_type, :user
set :rvm_ruby_version, '2.1.0'
set :deploy_user, 'deploy'

server '60.247.115.37', port: 3030, user: 'deploy', roles: %w{web app db}

set :deploy_to, "/srv/www/Jasmine"
set :rails_env, :development