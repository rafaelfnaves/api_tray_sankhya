set :application, "api_tray_sankhya"
set :repo_url, "git@bitbucket.org:rfnaves/api_tray_sankhya.git"
set :user, 'deploy'
set :puma_threads, [4, 16]
set :puma_workers, 0
set :stage, :production

# Deploy to the user's home directory
set :deploy_to, "/home/deploy/#{fetch :application}"

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle', 'public/system', 'public/uploads'

# Only keep the last 5 releases to save disk space
set :keep_releases, 5

# Optionally, you can symlink your database.yml and/or secrets.yml file from the shared directory during deploy
# This is useful if you don't want to use ENV variables
# append :linked_files, 'config/database.yml', 'config/secrets.yml'