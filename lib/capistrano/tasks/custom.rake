namespace :custom do
  task :reset_db do
    run "cd #{current_path} && bundle exec rake db:rollback STEP=100 RAILS_ENV=#{rails_env} db:migrate RAILS_ENV=#{rails_env} db:seed RAILS_ENV=#{rails_env}"
  end
end