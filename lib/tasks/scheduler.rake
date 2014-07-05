namespace :scheduler do
	desc "This task is called by the Heroku scheduler add-on to update restuarant db with json from DataSF Food Trucks"
	task :update_database => :environment do
  		puts "Updating database with DataSF..."
		# Vender.update
		puts "done."
	end
end