package com.csye6225.noteapp.beans;

import org.springframework.data.repository.CrudRepository;

import com.csye6225.noteapp.models.User;

public interface UserRepository extends CrudRepository<User, Integer> {

    //Added Later
    User findByemailAddress(String emailAddress);

}
