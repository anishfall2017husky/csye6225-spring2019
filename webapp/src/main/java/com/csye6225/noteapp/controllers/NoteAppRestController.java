package com.csye6225.noteapp.controllers;

import com.csye6225.noteapp.beans.UserRepository;
import com.csye6225.noteapp.models.User;


import com.csye6225.noteapp.services.UsersService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;


@RestController
@RequestMapping("/")
public class NoteAppRestController {

    @Autowired
    private UserRepository userRepository;

    private UsersService usersService;


    @RequestMapping(value="/", method= RequestMethod.GET, produces = "application/json")
    public ResponseEntity returnDate(){
        return new ResponseEntity(new Date(), HttpStatus.OK);
    }


    @RequestMapping(value = "/user/register", method = RequestMethod.POST, produces = "application/json")
    String addNewUser(@RequestParam String emailAddress
            , @RequestParam String password) {


        User existUser = userRepository.findByemailAddress(emailAddress);

        String flagExist = "false";

        if (existUser != null) {

            flagExist = "200 : User present";

        } else {
            User newUser = new User(emailAddress, password);

            userRepository.save(newUser);

            flagExist = "201 : User created";
        }

        return flagExist;


    }

}
