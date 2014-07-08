class TruckController < ApplicationController
	@@DISTANCE = 3.21869 # limiting distance we want to look for trucks in km (2mi)
	@@EARTH_RADIUS = 6371 # approximation of Earth's radius in km
	def index
		render text: "Cannot show nearby food trucks without a lat and lon.", status: :bad_request and return unless params["lat"] && params["lon"]
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

		trucks = nil
		if params["food"]
			trucks = Vehicle.joins({ vendor: :foods}, :location)
							.where("foods.name ilike ?", "%#{params['food']}%").where(status: "APPROVED")
							.where("lat BETWEEN ? AND ?", lat_min, lat_max).where("lon BETWEEN ? AND ?", lon_min, lon_max)
							.where("acos(sin(?) * sin(lat) + cos(?) * cos(lat) * cos(lon - ?)) <= ?", lat, lat, lon, angular_radius)
							# formula distance = arccos(sin(lat1) · sin(lat2) + cos(lat1) · cos(lat2) · cos(lon1 - lon2)) * earth_radius
							# doesn't take into account poles or the 180th Meridian
		else
			trucks = Vehicle.joins(:location).where(status: "APPROVED")
							.where("lat BETWEEN ? AND ?", lat_min, lat_max).where("lon BETWEEN ? AND ?", lon_min, lon_max)
							.where("acos(sin(?) * sin(lat) + cos(?) * cos(lat) * cos(lon - ?)) <= ?", lat, lat, lon, angular_radius)
		end
		respond_to do |format|
			format.json { render json: trucks }
			format.html { render :nothing }
		end
	end
end
