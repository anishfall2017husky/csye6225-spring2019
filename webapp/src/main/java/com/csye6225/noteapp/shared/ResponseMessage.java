package com.csye6225.noteapp.shared;


public enum ResponseMessage {

    USER_REGISTERATION_SUCCESS("User has been registered successfully"),
    USER_ALREADY_EXISTS("Email address is in use"),
    EMAIL_INVALID("Email is not valid. Please use another email address."),
    PASSWORD_INVALID("Password must be 8 or more characters"),
    NOT_LOGGED_IN("You are not logged in.");

    private String message;

    ResponseMessage(String message) {
        this.message = message;
    }

    public String getMessage() {
        return message;
    }
}
