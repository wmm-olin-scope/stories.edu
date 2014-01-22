var tag = document.createElement('script');
tag.src = "https://www.youtube.com/iframe_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

// 3. Define global variables for the widget and the player.
//    The function loads the widget after the JavaScript code
//    has downloaded and defines event handlers for callback
//    notifications related to the widget.
var widget;
var player;
function onYouTubeIframeAPIReady() {
widget = new YT.UploadWidget('widget', {
  	width: 500,
	  	events: {
	    	'onUploadSuccess': onUploadSuccess,
	    	// 'onStateChange': onPending,
	    	'onProcessingComplete': onProcessingComplete
	  	}
	});
}

// 4. This function is called when a video has been successfully uploaded.
function onUploadSuccess(event) {
	$( '#display' ).hide("slow");
	$( '#progressWrapper' ).show("slow");
	var url = 'http://www.youtube.com/watch?v='+event.data.videoId;
	$.ajax({
		type: 'PUT',
		url: "/story/youtube/story",
		settings: {youtubeUrl: url, tags: ["testing"]}
	}).done(function() {
		for ( var i = 10; i < 99; i=i+10 ){
			var percent = i.toString()+'%';
			$( '#bar' ).attr("aria-valuenow", i.toString()).delay(3000);;
			$( '#bar' ).css('width',percent).delay(3000);
		}
	});
	//alert('Video ID ' + event.data.videoId + ' was uploaded and is currently being processed.');
}


// 5. This function is called when a video has been successfully
//    processed.
function onProcessingComplete(event) {
	$( '#widget' ).hide("slow");
	$( '#progressWrapper' ).hide("slow");
	$ ( '#player' ).show("slow");
	player = new YT.Player('player', {
		width: 500,
		videoId: event.data.videoId,
		events: {}
	});
}