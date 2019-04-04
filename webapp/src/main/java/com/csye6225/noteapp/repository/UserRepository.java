package com.csye6225.noteapp.repository;

import org.springframework.data.repository.CrudRepository;

import com.csye6225.noteapp.models.User;

import javax.transaction.Transactional;

@Transactional
public interface UserRepository extends CrudRepository<User, Integer> {

    User findByemailAddress(String emailAddress);

}
