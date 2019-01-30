package com.csye6225.noteapp.services;

import com.csye6225.noteapp.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("userService")
public class UserService {

    @Autowired
    UserRepository userRepository;

    public boolean isEmailValid(String emailAddress) {
        String emailPattern = "[a-z0-9!#$%&\'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&\'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
        return emailAddress.matches(emailPattern);
    }

    public boolean isPasswordValid(String password) {
        return password.length() >= 8;
    }

}
