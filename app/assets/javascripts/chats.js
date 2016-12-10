jQuery(document).ready(function($) {
	$("#select_sexo").change(function(event) {
		var valor =  $(this).val();
		$.ajax({
			url: '/select_sexo',				
			data: {option: valor},
		})
		.done(function(data) {
			$('#chat-body').html(data);
		})
		.fail(function() {		
			$('#chat-body').html('<div class="alert alert-danger>Opss! ocorreu um erro!"</div>');
		});
		/* Act on the event */
	});
	
});




