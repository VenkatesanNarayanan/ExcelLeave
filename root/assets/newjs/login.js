        (function($, W, D)

            {
                var validator = {};
                validator.call = {
                    setupFormValidation: function() {
                        $("#register-form").validate({
                            rules: {
                                email: {
                                    required: true,
                                    email: true
                                },

                                password: {

                                    required: true,

                                    minlength: 5

                                },

                            },

                            messages: {

                                password: {

                                    required: "Please provide a password",

                                    minlength: "Your password must be at least 5 characters long"

                                },

                                email: "Please enter a valid email address",


                            },

                            submitHandler: function(form) {

                                form.submit();

                            }

                        });

                    }

                }

                $(D).ready(function($) {
                    function DisableBackButton() {
                        window.history.forward()
                    }
                    DisableBackButton();
                    window.onload = DisableBackButton;
                    window.onpageshow = function(evt) {
                        if (evt.persisted) DisableBackButton()
                    }
                    window.onunload = function() {
                        void(0)
                    }

                    $("input").focus(function() {
                        $('#error').hide();
                    });
                    validator.call.setupFormValidation();

                });



            })(jQuery, window, document);
