package com.csye6225.noteapp;

import com.csye6225.noteapp.models.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;


import java.util.Date;


@RestController
@RequestMapping("/")
public class NoteAppRestController {

    @Autowired
    private UserRepository userRepository;

    @RequestMapping(value="/", method= RequestMethod.GET, produces = "application/json")
    public Date greeting() {
        return new Date();
    }

    @RequestMapping(value = "/user/register", method = RequestMethod.POST, produces = "application/json")
    String addNewUser(@RequestParam String emailAddress
            , @RequestParam String password) {


        User existUser = userRepository.findByemailAddress(emailAddress);

        String flagExist="false";

        if(existUser!=null){

            flagExist="200 : User present";

        }
        else
        {
            User newUser = new User(emailAddress, password);

            userRepository.save(newUser);

            flagExist="201 : User created";
        };

        return flagExist;


    }

}
