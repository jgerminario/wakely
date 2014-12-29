$(document).ready(function(){
	var $color_me = $('#color_me');
	var $color_boxes = $color_me.find('li');
	var change_color = function() {
		$.post('/color')
		.done( function(data) {
			$color_boxes.eq(data.cell).css("background-color", data.color);
		});
	};
	$('#get_color').on('click', change_color);
});