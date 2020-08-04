$(document).on('turbolinks:load', function () {
  // handle new_note form response
  $("#new_note").on("ajax:success", function(event){
    const response = event.detail[0];
    $(".notes-container").prepend(response.template);
    $("#note_message").val("");
  }).on("ajax:error", function(event) {
    console.log('error event: ', event.detail);
  });
  // handle new_note form response
});
