package com.csye6225.noteapp;

import com.csye6225.noteapp.model.User;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import static org.springframework.web.bind.annotation.RequestMethod.GET;

@RestController
public class NoteAppRestController {


    @RequestMapping(value="/",method=GET)
    public User greeting(@RequestParam(value="username") String username, @RequestParam(value="password") String password) {
        return new User(username,
                password);
    }

}
