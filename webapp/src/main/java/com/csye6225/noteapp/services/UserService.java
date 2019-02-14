package com.csye6225.noteapp.services;

import com.csye6225.noteapp.models.User;
import com.csye6225.noteapp.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.nio.charset.Charset;
import java.util.Base64;

@Service("userService")
public class UserService  {

    
    @Autowired
    private UserRepository userRepository;


    public boolean isEmailValid(String emailAddress) {
        String emailPattern = "[a-z0-9!#$%&\'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&\'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
        return emailAddress.matches(emailPattern);
    }

    public boolean isPasswordValid(String password) {
        return password.length() >= 8;
    }

    // user authentication logic
    public User authentication(HttpServletRequest request) {

        String authorization = request.getHeader("Authorization");

        if (authorization != null && authorization.startsWith("Basic")) {

            // Authorization: Basic base64credentials
            String base64Credentials = authorization.substring("Basic".length()).trim();
            String credentials = new String(Base64.getDecoder().decode(base64Credentials), Charset.forName("UTF-8"));

            // credentials = username:password
            final String[] values = credentials.split(":", 2);
            User user = userRepository.findByemailAddress(values[0]);

            if (user == null) {
                return null;
            }

            BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
            boolean isPassSame = passwordEncoder.matches(values[1], user.getPassword());

            if (!isPassSame) {
                return null;
            }
            return user;

        }
        return null;

    }

    
 
}
