namespace :custom do
  task :reset_db do
    run "cd #{current_path} && bundle exec rake db:rollback STEP=100 RAILS_ENV=production db:migrate RAILS_ENV=production db:seed RAILS_ENV=production"
  end
end