	//Next step: get the lat and lon as variables available on the global scope so init can access them and use
	function init (){
		controller.userLocation.googleMapInit();
		//how to debug errors and this for example above?
		//Map is a constructure for google maps
	}
	// how to make this a class function instead of a global one? and why does this need to be outside of the $(document).ready call?

$(document).ready(function(){


	var Controller = function(args){
		this.view = args.view;
		this.model = args.model;
		this.userLocation = new UserLocation();
		if (document.getElementById('ampm')){
			document.getElementById('ampm').addEventListener('click', this.ampmListener);
		}
		if (document.getElementById('tweettextarea')){
			this.defaults();
			this.userLocation.getLocation();
		}
		this.checkGeoLocationConsent();
		var checkin = document.getElementById('checkin_form');
		var cbutton = document.getElementById('checkin_input');
		if (checkin){
			cbutton.addEventListener('click', function(e){
			  e.preventDefault();
			  this.userLocation.watchLocation();
                          e.target.parentNode.submit();
			}.bind(this)

		)}
	};

	var Model = function(){
	};

	var View = function(){
	};

	Controller.prototype = {
		ampmListener: function () {
			var ampm = document.getElementById('ampm_input');
			if (this.value == "am") {
				this.value = "pm";
				this.innerHTML = "pm";
				ampm.value = "pm";
			}
			else {
				this.value = "am";
				this.innerHTML = "am";
				ampm.value = "am";
			}
		},
		checkGeoLocationConsent: function () {
			if (localStorage.authorizedGeoLocation) {
				console.log(localStorage.authorizedGeoLocation);
			}
			else {
				this.userLocation.browserAlert();
			}
		},
		charCountListener: function () {
			$('#tweettextarea').on('keyup', this.getLength);
		},
		defaults: function () {
			$('#tweettextarea').val("I'm trying hard to wake up in the morning but it's not easy! Try it yourself at wake.ly");
			this.getLength();
			this.charCountListener();
		},
		getLength: function () {
			var len = $('#tweettextarea').val().length;
			$('.counter').text((140-len));
		},
		sendTweet: function () {

		},
		twitterAjax: function () {

		},
		twitterButtonListener: function () {
			// $("#auth").on('click', function(){
			// 	$.ajax({

			// 	});
			// });
		},
		twitterModalHandler: function(url) {
			// TODO: Implement a way to have the redirect window outside of the app itself
			// params = 'location=0,status=0,width=800,height=600';
			// var twitter_window = window.open(url, 'twitterWindow', params);
			// var interval = window.setInterval((function(){
			// 		if (this.twitter_window.closed) {
			// 		window.clearInterval(this.interval);
			// 		this.finish();
			// 	}
			// })).bind(this);
		}
	};

	controller = new Controller ({
		model: new Model(),
		view: new View()
	});

});
