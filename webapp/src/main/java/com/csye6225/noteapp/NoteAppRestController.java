package com.csye6225.noteapp;

import com.csye6225.noteapp.models.User;
import com.csye6225.noteapp.services.UsersService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;

@RestController
@RequestMapping("/")
public class NoteAppRestController {

    @Autowired
    private UsersService usersService;

    @RequestMapping(value="/", method= RequestMethod.GET, produces = "application/json")
    public Date greeting() {
        return new Date();
    }

    @RequestMapping(value = "/user/register", method = RequestMethod.POST, produces = "application/json")
    public User register(@RequestParam String username, @RequestParam String password) {
        User newUser = new User(username, password);
        return usersService.registerUser(newUser);
    }

}
