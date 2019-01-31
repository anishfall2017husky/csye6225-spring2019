package com.csye6225.noteapp.restApiTests;

import static org.junit.Assert.assertEquals;

import com.csye6225.noteapp.models.User;
import com.csye6225.noteapp.repository.UserRepository;

import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.web.servlet.MockMvc;

public class userRegisterTest{

    @Mock
    UserRepository userRepository;

    @Autowired
    MockMvc mockMvc;

    @Before
    public void setup(){
        MockitoAnnotations.initMocks(this);
        User u = new User();
        u.setEmailAddress("Unittest");
        u.setPassword("UnitTest111");
        Mockito.when(userRepository.findByemailAddress("Unittest")).thenReturn(u);
    }

    @Test
    public void testUserregister() throws Exception{
        User u = userRepository.findByemailAddress("Unittest");
        assertEquals(u.getEmailAddress(), "Unittest");
    }

}