(function(win){
	$(document).ready(function() {
		//initilization for Google Maps
		var markers = [], lastOpenedInfoWindow = null, view = null;
		_.templateSettings = {
			interpolate: /\<\@\=(.+?)\@\>/gim,
			evaluate: /\<\@([\s\S]+?)\@\>/gim,
			escape: /\<\@\-(.+?)\@\>/gim
		};
		var lastLocation = new google.maps.LatLng(37.73461, -122.39255); //starting (default) location
    	var map = new google.maps.Map(document.getElementById("map-canvas"), {
    		center: lastLocation,
    		zoom: 15,
    		zoomControl: true
    	});
    	var searchBox = new google.maps.places.Autocomplete($("#address")[0]);
		searchBox.bindTo('bounds', map);

		//define Backbone Collections
		var Locations = Backbone.Collection.extend({
			// gets location objets from server filtering by latitude and longitude
			url: function() {
				return this.food ? "/locations?lat=" + this.lat + "&lon=" + this.lon + "&food=" + this.food : "/locations?lat=" + this.lat + "&lon=" + this.lon;
			},
			initialize: function(models, options) {
				this.lat = options.lat;
				this.lon = options.lon;
				this.food = options.food;
			}
		});
		var Vendors = Backbone.Collection.extend({
			url: function() {
				return this.food ? "/location/" + this.id + "/info?food=" + this.food : "/location/" + this.id + "/info"
			},
			initialize: function(models, options) {
				this.id = options.id;
				this.food = options.food;
			}
		});

		//define Backbone Views
		var LocationsMapView = Backbone.View.extend({
			el: 'body',
			render: function (options) {
				(new Locations([], options)).fetch({
					success: function (locations) {
						removeAllMarkers(markers); //remove old markers
				        if (locations.models.length) {
				        	addNewMarkers(markers, locations, map, lastOpenedInfoWindow); //add new markers to map
				        } else {
				        	alert("Could not find any locations to match your search '" + locations.food + "'.");
				        }
				    }
				});
			}
		});

		view = (new LocationsMapView);
    	setupEventHandlers(map, lastLocation, view);

		//setting default location on map controls
    	$("#address").val("1679 Palou Avenue, San Francisco");
    	view.render({lat: lastLocation.lat(), lon: lastLocation.lng() });

    	//helper functions
		function setupEventHandlers(map, last, view) {
			google.maps.event.addListener(searchBox, 'place_changed', function() {
				var place = searchBox.getPlace();
				if (!place.geometry) { 
					alert("Could not find any location to match your search.  Please try again.");
					return;
				}
				updateMapsUI(map, last, place.geometry.location, view);
			});

			$("#food").keyup(function(e) {
				var foodText = $("#food").val() || null;
				var keyPressed = e.which || e.keyCode;
				if (keyPressed === 13) {
					view.render({
						lat: last.lat(),
						lon: last.lng(),
						food: foodText
					});
				}
			});

			$("#toggle_drawer").click(function(e) {
				$("#map_container").toggleClass("drawer_open");
				return false;
			});

			$("#clear").click(function(e) {
				var e = $.Event( "keyup", { which: 13 } );
				$("#food").val("");
				$("#food").trigger(e);
				return false;
			});

			$("#current_location").click(function(e) {
				if (navigator.geolocation) {
			        navigator.geolocation.getCurrentPosition(handleNavigatorFoundPosition);
			    } else { 
			        alert("Geolocation is not supported by this browser.");
			    }
				return false;
			});
		}
		function handleNavigatorFoundPosition(position) {
			$("#address").val("");
			updateMapsUI(map, lastLocation, new google.maps.LatLng(position.coords.latitude, position.coords.longitude), view);
		}

		function updateMapsUI(map, last, location, view) {
			last = location;
			map.setCenter(location);
			view.render({
				lat: location.lat(),
				lon: location.lng(),
				food: $("#food").val()
			});
		}

		function removeAllMarkers(markers) {
			for(var i = 0; i < markers.length; i++) {
				markers[i].setMap(null);
			}
			markers = [];
		}

		function addNewMarkers(markers, locations, map, lastOpenedInfoWindow) {
			// for each location, create a marker and add an event listener to display
			// information about Vendors in infoWindow on click
			var bounds = new google.maps.LatLngBounds();
    		_.each(locations.models, function(location) {
    			var marker = new google.maps.Marker({
    				position: new google.maps.LatLng(location.get('lat') * 180 / Math.PI, location.get('lon') * 180 / Math.PI),
    				map: map
    			});
    			bounds.extend(marker.getPosition());
			    google.maps.event.addListener(marker, 'click', function() { //should use event delegation here, performance concern
			    	(new Vendors([], { id: location.id, food: locations.food })).fetch({
			    		success: function(vendors) {
			    			var contentString = _.template($("#location_marker_info").html(), { information: vendors.models });
			    			var infowindow = new google.maps.InfoWindow({ content: contentString });
			    			infowindow.open(map,marker);
			    			lastOpenedInfoWindow = infowindow;
			    		}
			    	});
			    	if (lastOpenedInfoWindow) { lastOpenedInfoWindow.close(); }
			    });
			    markers.push(marker);
			});
	        map.fitBounds(bounds); //re-center map to include all markers
		}
	});
})(window);