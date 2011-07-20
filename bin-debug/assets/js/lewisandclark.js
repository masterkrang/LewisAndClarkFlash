// JavaScript Document

//window.document.write("from javascript file");


$(document).ready(function(){
	//window.document.write("hello");
	//alert("hello from js");
	
	$("#iframe").fancybox({
		 'width' : '75%',
         'height' : '75%',
         'autoScale' : false,
         'transitionIn' : 'none',
         'transitionOut' : 'none',
         'type' : 'iframe',
		 'hideOnContentClick': true	
	});
	
	//fancy box
}); 

function openDashboard(dashboardPath) {
	//window.document.write("openDashboard function called");
	//alert("openDashboard " + dashboardPath);
	
	callFancy(dashboardPath);
}

function callFancy(my_href) {
	console.log("callFancy " + my_href);
	var j1 = document.getElementById("iframe");
	j1.href = "http://live.deckmonitoring.com/?id=" + my_href; //ex: http://live.deckmonitoring.com/?id=akin_1
	//a;slkdfjka
	console.log("href = " + j1.href);
	$('#iframe').trigger('click');
}

//TWITTER

function getTweets() {
	
}
