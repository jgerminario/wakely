	//Next step: get the lat and lon as variables available on the global scope so init can access them and use
	function init (){
		controller.userLocation.googleMapInit("initial");
		//how to debug errors and this for example above?
		//Map is a constructure for google maps
	}
	function init_checkin (){
		console.log("before")
		controller.userLocation.googleMapInit("checkin");
		console.log("after")
	}
	// how to make this a class function instead of a global one? and why does this need to be outside of the $(document).ready call?

$(document).ready(function(){


	var Controller = function(args){
		this.view = args.view;
		this.model = args.model;
		this.userLocation = new UserLocation();
		this.checkGeoLocationConsent();
		this.svgLoader();
		// if (document.getElementById('ampm')){
		// 	document.getElementById('ampm').addEventListener('click', this.ampmListener);
		// }
		this.cbutton = document.getElementById('checkin_input');
		// console.log(this.cbutton);
		if (this.cbutton){
				this.inputSubmitListener();
			}
		if (document.getElementById('checkin_form')){
			setInterval(function(){
				this.userLocation.watchLocation();
			}.bind(this), 3000)
		}
		if (document.getElementById('step0')){
			this.stepButtonListener();
			this.splashLoad();
		}
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
		embarrassing: function () {
			i_num = 0
			$('#embarrassing').on('click', function(e){
				e.preventDefault();
				num = this.val;
				console.log(num)
				if (i_num == 0){
					$('#tweettextarea').val("I can't wait for the Nickelback concert tonight! #yolo");
					i_num++
				} else if (i_num == 1){
				} else{
				}
			})
		},
		getLength: function () {
			var len = $('#tweettextarea').val().length;
			$('.counter').text((140-len));
		},
		inputSubmitListener: function () {
			this.cbutton.addEventListener('click', function(e){
			  e.preventDefault();
			  this.userLocation.getLocation("checkin");
			}.bind(this));
		},
		nextStep: function (num) {
			var self = this
			$('#commitment').append("<div></div>").load('/step' + num + ' #step' + num, function(data){
				if (num == 2){
					self.userLocation.getLocation("initial");
				}
				if (num == 3){
					self.defaults();
					self.embarrassing();
				}
				if (num == 4){
				}
				console.log(num - 1)
				var step_str = '#step' + String(num-1);
				var $prev_page = $(step_str);
	    	$prev_page.css('display','none');
				self.svgLoader();
			})
		},
		sendTweet: function () {

		},
		splashLoad: function () {
			var splash_page = document.getElementById('step0');
			var self = this
			window.addEventListener('load', function() {
				var i = 0;                     //  set your counter to 1
				function listLoad () {           //  create a loop function
   				setTimeout(function () {    //  call a 3s setTimeout when the loop is called
      		$('#sp_item' + i).css('display','block')         //  your code here
     		 	i++;                     //  increment the counter
      		if (i < 5) {            //  if the counter < 10, call the loop function
         		listLoad();             //  ..  again which will trigger another 
      		}
      		if (i == 5){
      			setTimeout(function () {
      				self.nextStep(1);
      			}, 1000)
      		}                        //  ..  setTimeout()
   				}, 500)
			};
			listLoad();

				// setTimeout(function(){ 
				// 	$('#sp_sidetitle').css('display','block')
				// }, 1000);
				// setTimeout(function(){ 
				// 	$('#sp_item' + 1).css('display','block')
				// }, 1000);
				// for (var i=0; i<4; i++){
				// 	setTimeout(function(){ 
				// 		$('#sp_item' + i).css('display','block')
				// 	}, 1000);
				// }
			})
		},
		stepButtonListener: function () {
			var self = this
			$('form').on('click', '.next_button', function (e){
				e.preventDefault();
				next = Number(e.target.value);
				self.nextStep(next);
			})
		},
		// stepOneLoad: function () {
		// 	var self = this
		// 	$('#commitment').load('/step1 #step1', function(){
		// 		var $splash_page = $('#step0');
	 //    	$splash_page.css('display','none');
		// 		self.svgLoader();
		// 	}) // .hide().fadeIn('slow')
		// },
		stepTwoLoad: function () {

		},
		svgLoader: function () {
			$('img.svg').each(function(){
	    	var $img = $(this);
	    	var imgID = $img.attr('id');
	    	var imgClass = $img.attr('class');
	    	var imgURL = $img.attr('src');

	    	$.get(imgURL, function(data) {
	        // Get the SVG tag, ignore the rest
	        var $svg = $(data).find('svg');

	        // Add replaced image's ID to the new SVG
	        if(typeof imgID !== 'undefined') {
	            $svg = $svg.attr('id', imgID);
	        }
	        // Add replaced image's classes to the new SVG
	        if(typeof imgClass !== 'undefined') {
	            $svg = $svg.attr('class', imgClass+' replaced-svg');
	        }

	        // Remove any invalid XML tags as per http://validator.w3.org
	        $svg = $svg.removeAttr('xmlns:a');

	        // Replace image with new SVG
	        $img.replaceWith($svg);

	    	}, 'xml');

			});
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
