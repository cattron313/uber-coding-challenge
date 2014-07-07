namespace :scheduler do
	require "net/http"
	require "json"
	require 'bigdecimal'
	require 'bigdecimal/util'

	desc "This task is called by the Heroku scheduler add-on to update restuarant db with json from DataSF Food Trucks"
	task :update_database => :environment do
  		puts "Updating database with DataSF..."
  		data = get_JSON_data

 		data.sort! do |a, b|
 			a["objectid"] <=> b["objectid"]
 		end

 		Vehicle.find_each do |vehicle|
 			if blob = data.bsearch { |blob| blob["objectid"] <=> vehicle.datasf_object_id.to_s } # found record json match
 				data.delete(blob) # remove JSON objects that are already in db, so you are left with only new JSON objects to add to db

 				if blob["latitude"] && blob["longitude"]
	 				# update existing record if fields have changed
					vehicle.vendor.name = blob["applicant"] unless vehicle.vendor.name == blob["applicant"]
					vehicle.vehicle_type = blob["facilitytype"] unless vehicle.vehicle_type == blob["applicant"]
					vehicle.status = blob["status"] unless vehicle.status == blob["status"]

					lat = blob["latitude"].to_d.round(6)
					lon = blob["longitude"].to_d.round(6)
					if !vehicle.location.where(lat: lat, lon: lon).exists?
						if location = Location.find_by(lat: lat, lon: lon)
							vehicle.location = location
						else
							vehicle.location.create!(lat: lat, lon: lon, description: blob["locationdescription"], address: blob["address"])
						end
					end

					Food.parse_string(blob["fooditems"]).each do |option|
						option.strip!
						if !vehicle.vendor.foods.where(name: option).exists?
							if food = Food.find_by(name: option)
								vehicle.vendor.foods << food
							else
								vehicle.vendor.foods.create!(name: option)
							end
						end
					end
					vehicle.save!
				end
 			else
 				# destroy record in database that isn't present in json
 				raise "Vehicle with no vendor error #{vehicle.inspect}" unless vehicle.vendor
 				if vehicle.vendor.vehicles.size == 1
 					vehicle.vendor.destroy
 				else
 					vehicle.destroy
 				end
 			end
 		end

 		data.each do |blob| # create new record
 			if blob["latitude"] && blob["longitude"] && !Vehicle.exists?(datasf_object_id: blob["objectid"].to_i)
 				location = Location.find_by(lat: blob["latitude"].to_d.round(6), lon: blob["longitude"].to_d.round(6))
 				if !location
 					location = Location.new(lat: blob["latitude"].to_d.round(6), lon: blob["longitude"].to_d.round(6), description: blob["locationdescription"], address: blob["address"])
 					location.save!
 				end
 				vehicle = nil
				vendor = Vendor.find_by(name: blob["applicant"])
	 			vendor = Vendor.new(name: blob["applicant"]) if !vendor
	 			vendor.with_lock do
	 				vehicle = Vehicle.create!(vehicle_type: blob["facilitytype"], datasf_object_id: blob["objectid"].to_i, status: blob["status"], location: location)
		 			vendor.vehicles << vehicle
		 			vendor.save!
				end
 				
				Food.parse_string(blob["fooditems"]).each do |option|
					option.strip!
					if food = Food.find_by(name: option)
						vehicle.vendor.foods << food
						vehicle.save!
					else
						vehicle.vendor.foods.create!(name: option)
					end
				end
			end
 		end
		puts "done."
	end

	def get_JSON_data
		url = URI.parse('http://data.sfgov.org/resource/rqzj-sfat.json')
		req = Net::HTTP::Get.new(url.to_s)
		res = Net::HTTP.start(url.host, url.port) do |http|
		  http.request(req)
		end
		return JSON.parse(res.body)
	end
end