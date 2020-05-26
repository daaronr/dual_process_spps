$( document ).ready(function() {

  $('#subscribe-form').submit(function(e){
    e.preventDefault();
    var email_id = $("#email-id").val();
    if(email_id){
      var csrfmiddlewaretoken = csrftoken;
      var email_data = {"email-id": email_id, "csrfmiddlewaretoken" : csrfmiddlewaretoken};
      $.ajax({
        type : 'POST',
        url :  '/subscribe/',
        data : email_data,
        success : function(response){
          $('#email-id').val(''); 
          if(response.status == "404"){
            alert("This email is already been subscribed.");
          }
          else{
            $('#subscribe-form').html("<h3>Thank you for subscribing!</h3>");
          }
        },
        error: function(response) {
          alert("Something went wrong");
          $('#email-id').val(''); 
        }
      });
      return false;
    }
    else {
      alert("Please provide correct a correct email.");
    }
  });
 
  $('#subscribe-form-footer').submit(function(e){
    e.preventDefault();
    var email_id = $("#email-id-footer").val();
    if(email_id){
      var csrfmiddlewaretoken = csrftoken;
      var email_data = {"email-id": email_id, "csrfmiddlewaretoken" : csrfmiddlewaretoken};
      $.ajax({
        type : 'POST',
        url :  '/subscribe/',
        data : email_data,
        success : function(response){
          $('#email-id').val(''); 
          if(response.status == "404"){
            alert("This email is already been subscribed.");
          }
          else{
            $('#subscribe-form-footer').html("<h3>Thank you for subscribing!</h3>");
          }
        },
        error: function(response) {
          alert("Something went wrong");
          $('#email-id-footer').val(''); 
        }
      });
      return false;
    }
    else {
      alert("Please provide correct a correct email.");
    }
  });  

  function getCookie(name) {
      var cookieValue = null;
      if (document.cookie && document.cookie !== '') {
          var cookies = document.cookie.split(';');
          for (var i = 0; i < cookies.length; i++) {
              var cookie = jQuery.trim(cookies[i]);
              if (cookie.substring(0, name.length + 1) === (name + '=')) {
                  cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                  break;
              }
          }
      }
      return cookieValue;
  }
  var csrftoken = jQuery("[name=csrfmiddlewaretoken]").val();

  function csrfSafeMethod(method) {
      return (/^(GET|HEAD|OPTIONS|TRACE)$/.test(method));
  }
  $.ajaxSetup({
      beforeSend: function(xhr, settings) {
          if (!csrfSafeMethod(settings.type) && !this.crossDomain) {
              xhr.setRequestHeader("X-CSRFToken", csrftoken);
          }
      }
  })
});