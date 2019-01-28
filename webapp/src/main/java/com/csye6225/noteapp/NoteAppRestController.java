package com.csye6225.noteapp;

import com.csye6225.noteapp.models.User;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;

@RestController
@RequestMapping("/")
public class NoteAppRestController {

    @RequestMapping(value="/", method= RequestMethod.GET, produces = "application/json")
    public Date greeting() {
        return new Date();
    }

    @RequestMapping(value = "/user/register", method = RequestMethod.POST, produces = "application/json")
    public User createNewDatabase(@RequestParam String username, @RequestParam String password) {
        return new User(username, password);
    }

}
