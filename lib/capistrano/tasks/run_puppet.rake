desc "upload and run the puppet recipe"
task :puppet do
  on roles(:root) do |host|
    upload! "lib/puppet/rails-do.pp", "rails-do.pp"
    execute "puppet apply rails-do.pp"
  end
end
