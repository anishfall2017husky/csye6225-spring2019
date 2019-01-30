package com.csye6225.noteapp.controllers;

import com.csye6225.noteapp.models.GenericResponse;
import com.csye6225.noteapp.repository.UserRepository;
import com.csye6225.noteapp.models.User;

import com.csye6225.noteapp.services.UserService;
import com.csye6225.noteapp.shared.ResponseMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Date;


@RestController
public class UserController {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserService userService;


    @RequestMapping(value = "/", method = RequestMethod.GET, produces = "application/json")
    public ResponseEntity returnDate() {
        return new ResponseEntity(new Date(), HttpStatus.OK);
    }

    @RequestMapping(value = "/user/register", method = RequestMethod.POST, produces = "application/json")
    @ResponseBody
    public GenericResponse registerUser(@RequestBody User user) {
         User existUser = userRepository.findByemailAddress(user.getEmailAddress());

        if (existUser != null) {
            return new GenericResponse(HttpStatus.CONFLICT.value(), ResponseMessage.USER_ALREADY_EXISTS.getMessage());
        }

        if (!this.userService.isEmailValid(user.getEmailAddress())) {
            return new GenericResponse(HttpStatus.UNPROCESSABLE_ENTITY.value(), ResponseMessage.EMAIL_INVALID.getMessage());
        }

        if (!this.userService.isPasswordValid(user.getPassword())) {
            return new GenericResponse(HttpStatus.UNPROCESSABLE_ENTITY.value(), ResponseMessage.PASSWORD_INVALID.getMessage());
        }
        userRepository.save(user);

        logger.info("Create New User");

        return new GenericResponse(HttpStatus.CREATED.value(), ResponseMessage.USER_REGISTERATION_SUCCESS.getMessage());
    }

}
