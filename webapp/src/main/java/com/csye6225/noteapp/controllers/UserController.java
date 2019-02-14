package com.csye6225.noteapp.controllers;

import com.csye6225.noteapp.models.GenericResponse;
import com.csye6225.noteapp.models.Note;
import com.csye6225.noteapp.repository.NoteRepository;
import com.csye6225.noteapp.repository.UserRepository;
import com.csye6225.noteapp.models.User;

import com.csye6225.noteapp.services.UserService;
import com.csye6225.noteapp.shared.ResponseMessage;
import com.google.gson.JsonObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.google.gson.JsonObject;
import org.apache.commons.lang3.StringUtils;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.nio.charset.Charset;
import java.util.Base64;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import org.apache.commons.lang3.StringUtils;

import static java.time.Clock.systemUTC;

@RestController
public class UserController {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    private BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private NoteRepository noteRepository;

    @Autowired
    private UserService userService;

    @RequestMapping(value = "/", method = RequestMethod.GET, produces = "application/json")
    @ResponseBody
    public GenericResponse home(HttpServletRequest request, HttpServletResponse response) {

        String authorization = request.getHeader("Authorization");

        if (authorization != null && authorization.startsWith("Basic")) {

            // Authorization: Basic base64credentials
            String base64Credentials = authorization.substring("Basic".length()).trim();
            String credentials = new String(Base64.getDecoder().decode(base64Credentials), Charset.forName("UTF-8"));
            logger.info("credentials" + " = " + credentials);

            // credentials = username:password
            final String[] values = credentials.split(":", 2);
            logger.info("username/emailaddress" + " = " + values[0]);
            logger.info("password" + " = " + values[1]);
            User user = userRepository.findByemailAddress(values[0]);
            logger.info("user" + " = " + user);

            if (user == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                return new GenericResponse(HttpStatus.UNAUTHORIZED.value(), ResponseMessage.NOT_LOGGED_IN.getMessage());
            }

            BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
            boolean isPassSame = passwordEncoder.matches(values[1], user.getPassword());
            logger.info("Password query result" + " = " + isPassSame);

            if (!isPassSame) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                return new GenericResponse(HttpStatus.UNAUTHORIZED.value(), ResponseMessage.NOT_LOGGED_IN.getMessage());
            }

            response.setStatus(HttpServletResponse.SC_OK);
            return new GenericResponse(HttpStatus.OK.value(), new Date().toString());
        }

        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);

        return new GenericResponse(HttpStatus.UNAUTHORIZED.value(), ResponseMessage.NOT_LOGGED_IN.getMessage());
    }

    @RequestMapping(value = "/user/register", method = RequestMethod.POST, produces = "application/json")
    @ResponseBody
    public GenericResponse registerUser(@RequestBody User user, HttpServletRequest request,
            HttpServletResponse response) {

        User existUser = userRepository.findByemailAddress(user.getEmailAddress());

        if (existUser != null) {
            response.setStatus(HttpServletResponse.SC_CONFLICT);
            return new GenericResponse(HttpStatus.CONFLICT.value(), ResponseMessage.USER_ALREADY_EXISTS.getMessage());
        }

        if (!this.userService.isEmailValid(user.getEmailAddress())) {
            response.setStatus(HttpStatus.UNPROCESSABLE_ENTITY.value());
            return new GenericResponse(HttpStatus.UNPROCESSABLE_ENTITY.value(),
                    ResponseMessage.EMAIL_INVALID.getMessage());
        }

        if (!this.userService.isPasswordValid(user.getPassword())) {
            response.setStatus(HttpStatus.UNPROCESSABLE_ENTITY.value());
            return new GenericResponse(HttpStatus.UNPROCESSABLE_ENTITY.value(),
                    ResponseMessage.PASSWORD_INVALID.getMessage());
        }

        String hashedPassword = passwordEncoder.encode(user.getPassword());

        user.setPassword(hashedPassword);
        userRepository.save(user);

        logger.info("Created New User");
        response.setStatus(HttpServletResponse.SC_CREATED);

        return new GenericResponse(HttpStatus.CREATED.value(), ResponseMessage.USER_REGISTERATION_SUCCESS.getMessage());
    }

    // Get all notes for the user
    @GetMapping(value = "/note", produces = "application/json")
    public List<Note> getAllNotes(HttpServletRequest request, HttpServletResponse response) {

        User user = this.userService.authentication(request);

        if (user != null) {
            List<Note> notes = user.getNotes();
            logger.info("notes1 = " + notes);
            response.setStatus(HttpStatus.OK.value());
            return notes;
        }

        response.setStatus(HttpStatus.UNAUTHORIZED.value());
        return null;

    }

    // Create a note for the user
    @PostMapping(value="/note", produces = "application/json")
    public String createNote(@RequestBody Note noteReq, HttpServletRequest request, HttpServletResponse response) {

        JsonObject j = new JsonObject();

        try {

            User user = this.userService.authentication(request);

            if (user != null){

                Note note = new Note();

                if(!StringUtils.isBlank(noteReq.getContent()) && !StringUtils.isBlank(noteReq.getTitle())){

                    logger.info("Saving note");
                    UUID uuid = UUID.randomUUID();
                    note.setId(uuid.toString());
                    note.setContent(noteReq.getContent());
                    note.setTitle(noteReq.getTitle());
                    String currentDate = systemUTC().instant().toString();
                    note.setCreated_on(currentDate);
                    note.setLast_updated_on(currentDate);
                    note.setUser(user);
                    noteRepository.save(note);
                    logger.info("Note saved successfully!!!");
                    j.addProperty("Success", "Note Created");
                    response.setStatus(HttpServletResponse.SC_CREATED);

                } else {

                    j.addProperty("Error", "Content or Title is EMPTY.");
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);

                }

            } else {
                j.addProperty("Error", "Invalid User Credentials.");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            }

        } catch (IllegalStateException e) {
            j.addProperty("Exception", e.toString());

        } catch (Exception e) {
            j.addProperty("Exception", e.toString());
        }

        return j.toString();
    }

    // Get a note for the user
    @GetMapping(value="/note/{id}", produces = "application/json")
    public String getNote(@PathVariable String id, HttpServletRequest request, HttpServletResponse response) {

        JsonObject j = new JsonObject();

        try {

            User user = this.userService.authentication(request);

            if (user != null) {

                Note note = this.noteRepository.findById(id);

                if (note != null) {

                    if (user == note.getUser()) {

                        j.addProperty("id: ", note.getId());
                        j.addProperty("content: ", note.getContent());
                        j.addProperty("title: ", note.getTitle());
                        j.addProperty("created_on: ", note.getCreated_on());
                        j.addProperty("last_updated_on: ", note.getLast_updated_on());
                        response.setStatus(HttpServletResponse.SC_OK);

                    } else {

                        j.addProperty("Error", "You are not the owner of this note.");
                        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);

                    }

                } else {

                    j.addProperty("Error", "Note not found.");
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);

                }

            } else {

                j.addProperty("Error", "Invalid User Credentials.");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);

            }


        } catch (IllegalStateException e) {

            j.addProperty("Exception", e.toString());

        } catch (Exception e) {

            j.addProperty("Exception", e.toString());

        }

        return j.toString();



    }

    // Update a note for the user
    @PutMapping(value = "/note/{id}", produces = "application/json")
    public String updateNote(@RequestBody Note note, HttpServletRequest request, @PathVariable String id,
            HttpServletResponse response) {
        User user = this.userService.authentication(request);
        JsonObject j = new JsonObject();
        if (user != null) {
            Note n = this.noteRepository.findById(id);
            if (n != null) {
                if (!StringUtils.isBlank(note.getContent()) && !StringUtils.isBlank(note.getTitle())) {
                    if (user == n.getUser()) {
                        String currentDate = systemUTC().instant().toString();
                        n.setContent(note.getContent());
                        n.setTitle(note.getTitle());
                        n.setCreated_on(note.getCreated_on());
                        n.setLast_updated_on(currentDate);
                        j.addProperty("Success", "Updated Successfully!");
                        response.setStatus(HttpServletResponse.SC_NO_CONTENT);
                    } else {
                        j.addProperty("Error", "You are not the owner of this Note");
                        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    }

                } else {
                    j.addProperty("Error", "Content/Title cannot be empty or null.");
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                }
            } else {
                j.addProperty("Error", "Note Not Found!");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            j.addProperty("Error", "Invalid User Credentials.");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);

        }
        return j.toString();
    }

    // Delete a note for the user
    @DeleteMapping(value = "/note/{id}", produces = "*/*")
    public ResponseEntity deleteNote(@PathVariable String id, HttpServletRequest request,
            HttpServletResponse response) {

        User user = this.userService.authentication(request);
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return null;
        }

        Note note = this.noteRepository.findById(id);
        if (note == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return null;
        }

        if (!note.getUser().getEmailAddress().equals(user.getEmailAddress())) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return null;
        }

        int result = noteRepository.deleteNoteById(id);
        logger.info(String.valueOf(result));
        response.setStatus(HttpServletResponse.SC_NO_CONTENT);
        return null;
    }

}
