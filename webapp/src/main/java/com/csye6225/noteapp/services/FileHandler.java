package com.csye6225.noteapp.services;

import org.springframework.web.multipart.MultipartFile;

public interface FileHandler {

    public String uploadFile(MultipartFile multipartFile, String emailAddress) throws Exception;

    public String deleteFile(String fileLocation) throws Exception;

}
