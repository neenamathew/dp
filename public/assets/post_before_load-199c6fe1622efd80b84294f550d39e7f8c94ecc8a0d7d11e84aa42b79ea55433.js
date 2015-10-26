$(document).on('page:load', function(){

$("#comment").hide();
$(".form-group2 ").hide();

$(".sample ").hide();

$("#add_comment").click( function()
    { 
        $("#comment").show();
        $("#add_comment").hide();
                
     })   

 $(".button").click( function()
    { 
    	 $(this).parent().children('.form-group2').show();
         $(".sample ").show();
    	 $(this).hide();
     

     })


    });

