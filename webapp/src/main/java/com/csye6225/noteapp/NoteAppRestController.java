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

        User n = new User(emailAddress, password);
        userRepository.save(n);
        return "DML Success";
    }

    @RequestMapping(value = "/user/check", method = RequestMethod.POST, produces = "application/json")
    public @ResponseBody
    String checkUser(@RequestParam String emailAddress) {

        User n2 = userRepository.findByemailAddress(emailAddress);

        String flag="false";


        if(n2!=null){
            flag="Sucess";
        }
        else
        {
            flag="Failed";
        };

        return flag;

    }



}
