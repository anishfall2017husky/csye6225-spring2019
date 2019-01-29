package com.csye6225.noteapp.services;

import com.csye6225.noteapp.models.User;
import org.springframework.stereotype.Service;

@Service
public class UsersService {

    public User registerUser(User user) {
        String emailAddress = user.getEmailAddress();
        String password = user.getPassword();

        if (!isEmailValid(emailAddress)) {
            return null;
        }
        if (!isPasswordValid(password)) {
            return null;
        }
        return user;
    }

    private boolean isEmailValid(String emailAddress) {
        String emailPattern = "[a-z0-9!#$%&\'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&\'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
        return emailAddress.matches(emailPattern);
    }

    private boolean isPasswordValid(String password) {
        return password.length() > 8;
    }
}
