package com.csye6225.noteapp.restApITests;

import com.csye6225.noteapp.models.User;
import com.csye6225.noteapp.repository.UserRepository;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.web.servlet.MockMvc;

import static org.junit.Assert.assertEquals;

public class userRegisterTest {

    @Mock
    UserRepository userRepository;

    @Autowired
    MockMvc mockMvc;

    @Before
    public void setup() {

        MockitoAnnotations.initMocks(this);
        User u = new User();
        u.setEmailAddress("test@test.com");
        u.setPassword("test12345");
        Mockito.when(userRepository.findByemailAddress("test@test.com")).thenReturn(u);
    }

    @Test
    public void testUserregister() throws Exception {

        User u = userRepository.findByemailAddress("test@test.com");
        assertEquals(u.getEmailAddress(), "test@test.com");

    }
}
