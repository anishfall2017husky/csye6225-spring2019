package com.csye6225.noteapp;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.csye6225.noteapp.models.User;
import com.csye6225.noteapp.UserRepository;

@Controller
@RequestMapping(path="/account_auth")
public class MainController {
    @Autowired
    private UserRepository userRepository;

    @GetMapping(path = "/add")
    public @ResponseBody
    String addNewUser(@RequestParam String emailAddress
            , @RequestParam String password) {

        User n = new User(emailAddress, password);
        userRepository.save(n);
        return "DML Success";
    }

    @GetMapping(path = "/check")
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
