// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs

//= require moment
//= require bootstrap-datepicker
//= require bootstrap-datepicker/locales/bootstrap-datepicker.pt-BR.js
//= require twitter/bootstrap/modal

//= require jquery.remotipart
//= require turbolinks
//= require bootstrap-toggle
//= require maskedinput
//= require_tree .
//= require_tree ./channels

$(document).on('ready page:change', function() {
  $('input[type="checkbox"].toggle').bootstrapToggle(); // assumes the checkboxes have the class "toggle"


});

function msnToBotton(alt) {
	var alt = parseInt($(document).height());
	var cal = alt + 200;
	$('html, body').animate({scrollTop: cal}, 800);
}

jQuery(document).ready(function($) {
	
	$.fn.datepicker.defaults.language = 'pt-BR';	
	var local = window.location.pathname;
	var temp = local.slice(-6);
	
	if (temp == '/chats') {
		setInterval(function(){
			getUserOnline();
		},10000);
	}

	var alt = $(this).height();	
	if (alt > $(this).scrollTop()) {
		$("message-content").focus();
		msnToBotton(alt);
	}
	
  

});

function getUserOnline() {
	$.ajax({
		url: '/user-online',		
	})
	.done(function(data) {
		console.log("sucesso");
	})
	.fail(function() {
		console.log("error");
	})
	.always(function() {
		console.log("complete");
	});
	
}



$(document).keypress(function (e) {      
        if(e.keyCode == 13) {
			var doc = $(document);
			var alt = doc.height();
			if ($(document).scrollTop() > alt-800) {
				msnToBotton(alt)
			}	
		}
	});



$(window).scroll(function(event) {
	var alt = parseInt($(document).height());
	
	if ($(document).scrollTop() < alt-1300) {		
		$('.btn-toBottom').fadeIn(400);
	} else {
		$('.btn-toBottom').fadeOut(400);
	}
});

$('.btn-toBottom').click(function(event) {      
    var alt = $(document).height();
    msnToBotton(alt);
});

$('.datepicker').datepicker({    
      'autoclose': true
    });    