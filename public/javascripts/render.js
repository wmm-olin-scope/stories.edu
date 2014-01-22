$( document ).ready(function() {
	var src = "http://www.youtube.com/embed/0oDJKlLLbAQ?list=UUgfK5EqE5sD2odn_5rwU4VQ"
  	$("#youtubeframe").html("<iframe width='500' height='300' src='"+src+"' frameborder='0' allowfullscreen></iframe>");
});

$( "#story-button" ).click(function() {
	var src = $("#youtubeurl").val();
  	$("#youtubeframe").html("<iframe width='500' height='300' src='"+src+"' frameborder='0' allowfullscreen></iframe>");
  	var prompt = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum rhoncus vulputate nulla, sed pulvinar enim placerat in. Maecenas faucibus, nibh et dictum dignissim, leo diam dignissim libero, porttitor congue sapien arcu ac mi. Suspendisse sit amet vestibulum nisl.";
  	$("#promptframe").html("<p>"+prompt+"</p><br><center><input type='text' class='form-control' placeholder='Name your clip' id='inputSmall'><input type='text' class='form-control' placeholder='Tag your clip' id='inputSmall'><button id='share-button' name='share-button' class='btn btn-default'>Submit</button><br><br>Tell your friends...<br><i class='fa fa-facebook-square fa-3x'></i>&nbsp;&nbsp;&nbsp;&nbsp;<i class='fa fa-twitter-square fa-3x'></i></center>");
  	$("#story-button").remove();
});