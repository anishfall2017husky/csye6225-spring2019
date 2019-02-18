package com.csye6225.noteapp.services;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@Service
public class LocalFileHandler implements FileHandler {

    private String tmpFolder = "tmp";

    @Override
    public String uploadFile(MultipartFile multipartFile, String emailAddress) throws Exception {
        byte[] bytes = multipartFile.getBytes();
        Path path = Paths.get(tmpFolder, emailAddress);
        if (!Files.exists(path)) {
            Files.createDirectory(path);
        }
        path = Paths.get(tmpFolder, emailAddress, multipartFile.getOriginalFilename());
        Files.write(path.toAbsolutePath(), bytes);
        return path.toString();
    }

    @Override
    public String deleteFile(String fileLocation) throws Exception {
        return null;
    }
}
