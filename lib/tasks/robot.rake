namespace :robot do
  desc 'create admin'
  task :create_admin=>:environment do
    while true do
      puts '*****Create the admin account'
      print '*****Input your username:' 
      username=STDIN.gets.chomp
      print '*****Input your password:'
      password=STDIN.gets.chomp
      unless username.blank? || password.blank?
        p Admin.create(:username=>username, :password=>password)
        break
      else
        puts '*****username or password can\'t be blank.*****'
      end
    end
  end

	desc 'clear histroy'
	task :clear_histroy => :environment do
		count = ENV["count"].to_i
		if count.present? && count > 0
			Robot.order("id").limit(count).delete_all
		else
			Robot.delete_all
		end
		puts "successfully delete #{count} history"
	end
end
