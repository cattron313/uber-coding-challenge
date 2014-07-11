require 'json'
class LocationController < ApplicationController
  	@@DISTANCE = 2.414016 # limiting distance we want to look for trucks in km (1.5mi)
	@@EARTH_RADIUS = 6371 # approximation of Earth's radius in km
	def index
		render text: "Cannot show nearby locations without a lat and lon.", status: :bad_request and return unless params["lat"] && params["lon"]
		lat = Location.convert_lat_or_lon_to_d(params["lat"])
		lon = Location.convert_lat_or_lon_to_d(params["lon"])
		puts "LAT:#{lat}", "LON:#{lon}"

		angular_radius =  @@DISTANCE / @@EARTH_RADIUS
		lat_min = lat - angular_radius
		lat_max = lat + angular_radius
		puts "LAT_MAX:#{lat_max}", "LAT_MIN:#{lat_min}"

		delta_lon = Math.asin(Math.sin(angular_radius) / Math.cos(lat))
		lon_min = lon - delta_lon
		lon_max = lon + delta_lon
		puts "LON_MAX:#{lon_max}", "LON_MIN:#{lat_min}"

		locations = nil
		if params["food"]
			locations = Location.joins({ vehicles: { vendor: :foods}})
							.where("foods.name ilike ?", "%#{params['food']}%").where("status = 'APPROVED'")
							.where("lat BETWEEN ? AND ?", lat_min, lat_max).where("lon BETWEEN ? AND ?", lon_min, lon_max)
							.where("acos(sin(?) * sin(lat) + cos(?) * cos(lat) * cos(lon - ?)) <= ?", lat, lat, lon, angular_radius)
							# formula distance = arccos(sin(lat1) · sin(lat2) + cos(lat1) · cos(lat2) · cos(lon1 - lon2)) * earth_radius
							# doesn't take into account poles or the 180th Meridian
		else
			locations = Location.joins(:vehicles).where("status = 'APPROVED'")
							.where("lat BETWEEN ? AND ?", lat_min, lat_max).where("lon BETWEEN ? AND ?", lon_min, lon_max)
							.where("acos(sin(?) * sin(lat) + cos(?) * cos(lat) * cos(lon - ?)) <= ?", lat, lat, lon, angular_radius)
		end
		respond_to do |format|
			format.json { render json: locations }
			format.html { render :nothing }
		end
	end

	def info
		render text: "Cannot show location info without an id", status: :bad_request and return unless params["id"]
		location = Location.find(params["id"])
		info = []
		unique_vendors_at_location = Vendor.joins(vehicles: :location).where("locations.id = ?", params["id"]).uniq
		unique_vendors_at_location.each do |vendor|
			info << {name: vendor.name, address: location.address, food_items: vendor.food_description }
		end
		respond_to do |format|
			format.json { render json: info.to_json}
			format.html { render :nothing }
		end
	end
end
