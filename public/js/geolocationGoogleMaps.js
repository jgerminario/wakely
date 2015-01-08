var loc = document.getElementById('location');
var error = "Sorry, we were unable to get your location";

var UserLocation = function () {
	this.browser = {};
	this.browserClass = "";
};

UserLocation.prototype = {
	getLocation: function(type) {
		// if (Modernizr.geolocation) {
			// Modernizr takes a great deal of time with the whole library loaded. TODO: modularize this later
			if (type == "initial") {
				var geoOptions = {
	     		timeout: 20 * 1000,
	     		maximumAge: 120000
	  		};
	  	}
  		else {
				var geoOptions = {
	     		timeout: 20 * 1000,
	     		maximumAge: 40000
	  		};
  		}

  		var self = this;
			navigator.geolocation.getCurrentPosition(function(position) 
				{
					self.showPosition(position, type);
				}.bind(this), self.showError.bind(this),geoOptions);
				// need to bind because otherwise these uncalled functions will get bound to navigator, which ends up tied to the window object, giving us error when we call 'showInMap' in 'showPosition'
		// }
		// else {
			// loc.innerHTML = "<p>" + error + "</p>;";
		// }
	},
	getBrowser: function(){
    var nav=navigator.appName;
    var ua=navigator.userAgent; 
    var tem;
    var match=ua.match(/(opera|chrome|safari|firefox|msie)\/?\s*(\.?\d+(\.\d+)*)/i);
    if(match && (tem= ua.match(/version\/([\.\d]+)/i))!= null) M[2]= tem[1];
    match=match? [match[1], match[2]]: [nav, navigator.appVersion, '-?'];
    return match[0];
  },
 	browserAlert: function(){
    browser = this.getBrowser().toLowerCase();
    $("#message").addClass(browser).css("display", "block");
    // TODO: fade this in and out instead of persisting
	},
	watchLocation: function(){
		var geoOptions = {
   		timeout: 30000,
   		maximumAge: 3000,
   		enableHighAccuracy: true
		};
		var self = this;
		navigator.geolocation.getCurrentPosition(function(position) 
			{
				self.showPosition(position, "checkinWatch");
			}.bind(this), this.showError.bind(this),geoOptions);
	},
	loadGoogleMapScript: function (test) {
		var script = document.createElement('script');
		if (test == "initial"){
			script.src = "http://maps.googleapis.com/maps/api/js?sensor=false&callback=init";
			document.body.appendChild(script);
		}
		else {
			if (this.localMap) {
				this.marker.setPosition(new google.maps.LatLng(this.lat, this.lon));
			}
			else {
			script.src = "http://maps.googleapis.com/maps/api/js?sensor=false&callback=init_checkin";
			document.body.appendChild(script);
			}

		}
		// what does 'sensor' do? callback calls the initialization
		
		// we need specific scripts from Google to allow the map object to work properly, thus the appending of this script
	},
	// showInMap: function(latlon) {
		// var map_url = "http://maps.googleapis.com/maps/api/staticmap?center=" + latlon + "&zoom=14&size=400x300&sensor=false";
		// document.getElementById("map").innerHTML = "<img src='" + map_url + "'>";
		// simple Google Map implementation (using straight URL and image)
	// },
	showPosition: function(position, test) {
		$("#message").css('display','none');
		localStorage.authorizedGeoLocation = 1;
		this.lat = position.coords.latitude;
		this.lon = position.coords.longitude;
		console.log (this.lat + " " + this.lon)
		console.log(test)
		if (test == "initial" || test == "checkinWatch"){
			this.loadGoogleMapScript(test);
		}
		if (test == "checkinWatch") {
			console.log(this.lat, this.lon);
			console.log(position.coords.accuracy);
			this.outputCoords(this.lat, this.lon);
		}
		if (test == "checkin") {
			console.log(this.lat, this.lon);
			console.log(position.coords.accuracy);
			this.outputCoords(this.lat, this.lon);
			document.getElementById("checkin_form").submit();			
		}
		// this.showInMap(position.coords.latitude + "," + position.coords.longitude);
	},
	outputCoords: function(lat,lon) {
		document.getElementById("checkin_lat").value = lat;
		document.getElementById("checkin_lon").value = lon;
		console.log(document.getElementById("checkin_lon").value);
	},
	showError: function(error) {
		// switch(*.code) will read the code of the error to see what gets returned
		$("#message").css("display", "none");
		localStorage.authorizedGeoLocation = 0;
		console.log(error);
	 //    switch(error.code) {
	 //        case error.PERMISSION_DENIED:
	 //            x.innerHTML = "User denied the request for Geolocation."
	 //            break;
	 //        case error.POSITION_UNAVAILABLE:
	 //            x.innerHTML = "Location information is unavailable."
	 //            break;
	 //        case error.TIMEOUT:
	 //            x.innerHTML = "The request to get user location timed out."
	 //            break;
	 //        case error.UNKNOWN_ERROR:
	 //            x.innerHTML = "An unknown error occurred."
	 //            break;
	 // // examples of defined error messages
  },
  getWalkingTime: function (distance) {
  	return Math.round(20 * distance); // 20 minute mile
  },
  displayInfo: function (widget) {
	  var info = document.getElementById('info');
	  var distance_input = document.getElementById('distance-input');
	  var position_input = document.getElementById('position-input');
	  distance = Math.round(widget.get('distance')*0.621371*100)/100;
	  info.innerHTML = 'Distance: ' + distance + ', walking time: ' + this.getWalkingTime(distance) + " minutes";
	  distance_input.value = distance;
	  position_input.value = widget.get('position');
	},
  googleMapInit: function (type) {
  	if (type == "initial") {
  		lat = this.lat;
  		lon = this.lon;
  	}
  	else {
  		lat = document.getElementById("v_lat").value
  		lon = document.getElementById("v_lon").value
  	}
    var mapOptions = {
			center: new google.maps.LatLng(lat, lon),
			mapTypeId: google.maps.MapTypeId.ROADMAP,
			zoom: 14
		};
		this.localMap = new google.maps.Map(document.getElementById('map'), mapOptions);
		var location = new google.maps.LatLng(lat, lon);

		if (type == "checkin"){
		  var circle = new google.maps.Circle({
      strokeColor: '#FF0000',
      strokeOpacity: 0.8,
      strokeWeight: 2,
      fillColor: '#FF0000',
      fillOpacity: 0.35,
      radius: 402.336,
      map: this.localMap,
      center: location
 			 });

		  this.marker = new google.maps.Marker({
		  	map: this.localMap,
		  	position: new google.maps.LatLng(this.lat, this.lon)
		  })
		}
		else {

		DistanceWidget.prototype = new google.maps.MVCObject();
		RadiusWidget.prototype = new google.maps.MVCObject();
		RadiusWidget.prototype.distance_changed = function() {
  		this.set('radius', this.get('distance') * 1000); // to meters from km
		};
		RadiusWidget.prototype.center_changed = function() {
		  var bounds = this.get('bounds');
		  if (bounds) {
		    var lng = bounds.getNorthEast().lng();
		    var position = new google.maps.LatLng(this.get('center').lat(), lng); //gets the center position and gives the latitude of it, same with lng
		    this.set('sizer_position', position);
		  }
		};
		RadiusWidget.prototype.addSizer_ = function() {
			var image = {
				url: 'imgs/resizer.png',
		    size: new google.maps.Size(50,50),
		    origin: new google.maps.Point(0,0),
		    anchor: new google.maps.Point(25,25)
			};
		  var sizer = new google.maps.Marker({
		    draggable: true,
		    title: 'Drag me!',
		    icon: image
		  });

		  sizer.bindTo('map', this);
		  sizer.bindTo('position', this, 'sizer_position');
		  var me = this;
			google.maps.event.addListener(sizer, 'drag', function() {
			  // Set the circle distance (radius)
			  me.setDistance();
			});
		};
		RadiusWidget.prototype.distanceBetweenPoints_ = function(p1, p2) {
			  if (!p1 || !p2) {
			    return 0;
			  }

			  var R = 6371; // Radius of the Earth in km
			  var dLat = (p2.lat() - p1.lat()) * Math.PI / 180;
			  var dLon = (p2.lng() - p1.lng()) * Math.PI / 180;
			  var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
			    Math.cos(p1.lat() * Math.PI / 180) * Math.cos(p2.lat() * Math.PI / 180) *
			    Math.sin(dLon / 2) * Math.sin(dLon / 2);
			  var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
			  var d = R * c;
			  return d;
			};
		/**
		 * Set the distance of the circle based on the position of the sizer.
		 */
		RadiusWidget.prototype.setDistance = function() {
		  // As the sizer is being dragged, its position changes.  Because the
		  // RadiusWidget's sizer_position is bound to the sizer's position, it will
		  // change as well.
		  var pos = this.get('sizer_position'); //programmatically gets the position of the sizer, specifically
		  var center = this.get('center');
		  var distance = this.distanceBetweenPoints_(center, pos);

		  // Set the distance property for any objects that are bound to it
		  this.set('distance', distance);
		};
		var distanceWidget = new DistanceWidget(this.localMap, location);
		google.maps.event.addListener(distanceWidget, 'distance_changed', function() {
			  this.displayInfo(distanceWidget);
			}.bind(this));
  	

			google.maps.event.addListener(distanceWidget, 'position_changed', function() {
			  this.displayInfo(distanceWidget);
			});
			this.displayInfo(distanceWidget);
		}	

	}
};

function DistanceWidget(localmap, location) {
  this.set('map', localmap);
  this.set('position', localmap.getCenter());

  var marker = new google.maps.Marker({
    title: 'Move me!',
		animation: google.maps.Animation.DROP
  });

  marker.bindTo('map', this);
  marker.bindTo('position', this);
	var radiusWidget = new RadiusWidget(localmap, location);
	radiusWidget.bindTo('map', this);
	radiusWidget.bindTo('center', this, 'position');
	// Bind to the radiusWidgets' distance property
	this.bindTo('distance', radiusWidget);
	// Bind to the radiusWidgets' bounds property
	this.bindTo('bounds', radiusWidget);
	}

function RadiusWidget(localMap, location) {
	console.log(this);
	console.log(location);
  var circle = new google.maps.Circle({
      strokeColor: '#FF0000',
      strokeOpacity: 0.8,
      strokeWeight: 2,
      fillColor: '#FF0000',
      fillOpacity: 0.35
  });

  this.set('distance', 0.402336); //quarter of a mile
  this.bindTo('bounds', circle);
  circle.bindTo('center', this);
  circle.bindTo('map', this);
  circle.bindTo('radius', this);
  this.addSizer_();
}
