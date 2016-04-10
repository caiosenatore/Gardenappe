/*
 Ajax Callback function
 */
function ajax_callback(form, gogogo) {
    form.submit(function (e) {
            $.ajax({
                type: "POST",
                url: $(this).attr('action'), //sumbits it to the given url of the form
                data: $(this).serialize(),
                dataType: "JSON" // you want a difference between normal and ajax-calls, and json is standard
            }).success(function (data) {
                /*
                 Log JSON
                 */
                console.log(data);

                /*
                 Clear the red marks on form fields
                 */
                form_validation_red_back(form)

                /*
                 Check validations, if controller returns
                 */
                if (validated(data)) {
                    /*
                     go go go... Wait, has business messages?
                     */
                    if (data.message != null) {
                        show_message_modal(data.message)
                    } else {
                        /*
                         Now it' ok! go go go
                         */
                        gogogo(data)
                    }
                } else {
                    /*
                     Show alert
                     */
                    show_validation_modal(validation_messages_display(data))
                }
            }).fail(function (request, textStatus, errorThrown) {
                alert("Somenthing wrong! " + errorThrown)
            });

            e.preventDefault()
        }
    );
}

function singles(single_url, callback) {
    $.ajax({
        type: "GET",
        url: single_url,
        dataType: "JSON" // you want a difference between normal and ajax-calls, and json is standard
    }).success(function (data) {
        callback(data.single);
    })
}

function load_parts(url, callback) {
    $.ajax({
        type: "GET",
        url: url,
        dataType: "HTML"
    }).success(function (data) {
        callback(data);
    })
}

function validated(data) {
    if (data.validations != null) {
        if (Object.keys(data.validations).length > 0) {
            return false
        } else {
            return true
        }
    } else {
        return true
    }
}

function validation_messages_display(data) {
    message = ""

    for (var key in data.validations) {
        var field = key;
        var field_data = data.validations[key];
        for (var m in field_data) {
            message = message + "<li>" + field + ": " + field_data[m] + "</li>"
        }

        validation_field_warning(field)
    }

    return message
}

function validation_field_warning(field) {
    $("#" + field).addClass("has-error")
}

function form_validation_red_back(form) {
    $.each(form[0].getElementsByClassName("has-error"), function (i) {
        $(this).removeClass("has-error")
    })
}

function show_message_modal(message) {
    $('#modal_message #modal_validation_messages').html(message)
    $('#modal_message').modal() // Open!
}

function show_validation_modal(validation_messages) {
    $('#modal_validation #modal_validation_messages').html(validation_messages)
    $('#modal_validation').modal() // Open!
}

function redirect(data) {
    if (data.redirect_url != null) {
        window.location.href = data.redirect_url
    }
}

function redirect_to(url) {
    window.location.href = url
}