set :stage, :staging

# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server "example.com", user: "deploy", roles: %w{app db web}, my_property: :my_value
# server "example.com", user: "deploy", roles: %w{app web}, other_property: :other_value
# server "db.example.com", user: "deploy", roles: %w{db}


# using extended syntax (which is equivalent)

# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

# role :app, %w{deploy@example.com}, my_property: :my_value
# role :web, %w{user1@primary.com user2@additional.com}, other_property: :other_value
# role :db,  %w{deploy@example.com}



# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.



# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# The server-based syntax can be used to override options:
# ------------------------------------
# server "example.com",
#   user: "user_name",
#   roles: %w{web app},
#   ssh_options: {
#     user: "user_name", # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: "please use keys"
#   }

# set :application, 'project-houston-server'
# set :deploy_to, '/var/www/test'
  # ask(:source) if fetch(:source) == nil
 	# ask(:destination) if fetch(:destination) == nil

server "192.168.1.211",
  user: "pi",
  roles: %w{web},
  ssh_options: {  
    keys: %w(/home/user_name/.ssh/id_rsa),
  }

server "192.168.1.212",
  user: "pi",
  roles: %w{web},
  ssh_options: {
    keys: %w(/home/user_name/.ssh/id_rsa),
  }

role :web, %w{192.168.1.211,192.168.1.212}

desc 'Get locations'
task :get_location do
  set :source , ARGV[2]
  set :destination , ARGV[3]
end



desc "Update text file with another text file"
task :update_file do
  invoke :get_location
  on roles(:web) do |host|
    upload!("#{fetch(:source)}", "/home/pi/update_files")
    execute "./set_up.sh #{fetch(:source).split('/').last} #{fetch(:destination)} "

  end
end

desc 'get command'
task :get_command do
  set :command, ARGV[2]
end

desc "Execute a command that accepts up to 8 words  "
task :execute_command do
  invoke :get_command
  on roles(:web) do |host|
    execute "./execute.sh #{fetch(:command)} "
  end
end

    # execute "cp #{fetch(:source)} #{fetch(:destination)}"
    # info "#{fetch(:source)} #{fetch(:destination)}"

    #/home/chan/Desktop/NextWork/test.txt /home/pi

    # info "Host #{host} (#{host.roles.to_a.join(', ')}):\t#{capture(:update_file)}"

    #cap staging execute_command "chmod 777 test.txt"

    #cap staging update_file /home/chan/Desktop/NextWork/test.txt /home/pi
