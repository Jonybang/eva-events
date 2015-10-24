namespace :deploy do
  desc 'Invoke rake task'
  task :invoke do
    on roles(:app) do
      within "#{current_path}" do
        with rails_env: :production do
          execute :rake, ENV['task']
          # !!!see NOTE at end of answer!!!
        end
      end
    end
  end
  task :reset_db do
    on roles(:app) do
      within "#{current_path}" do
        with rails_env: :production do
          execute :rake, 'db:rollback STEP=100 db:migrate db:seed'
          # !!!see NOTE at end of answer!!!
        end
      end
    end
  end
end
