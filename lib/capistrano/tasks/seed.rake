namespace :db do
  desc "seed the db"
  task :seed do
    on roles :db do
      within release_path do
        execute :rake, "db:seed", "RAILS_ENV=production"
      end
    end
  end
end
