function createMessageChannel() {
	var style = '';
	
	
	App.messages = App.cable.subscriptions.create({
		
		channel: 'MessagesChannel', chat_id: parseInt($("#message_chat_id").val())
	},
	{
		received: function(data) {
			$("#messages").removeClass('hidden');
			
			var current_id = $("#message_user_id").val();			
			
			if (current_id == data.user_id) {								
				style = 'content_ballon_user_current';					
			} else {				
				style = 'content_ballon';	
			}

			var alt = parseInt($(document).height());
			var cal = alt + 200;
			if ($(document).scrollTop() > alt-800) {
				$('html, body').animate({scrollTop: cal}, 800);
			}
			$('html, body').css('margin-bottom', '30px');
			return $('#messages').append(this.renderMessage(data))
			
			
		},

		renderMessage: function(data) {					
			return "<ul class='msn'> <li class='"+style+"'>"+ data.message +"</li></ul>";
		}
		
	});
	
	return App.messages;
}


