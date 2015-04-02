namespace :db do

  desc "seed the db"
  task :seed do
    on roles :db do
      within "/home/deploy/basketball-referee-generator" do
        execute :git, "pull"
      end
      within release_path do
        execute :rake, "db:seed", "RAILS_ENV=production"
      end
    end
  end

end
