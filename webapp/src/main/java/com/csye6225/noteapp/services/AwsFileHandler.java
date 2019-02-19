package com.csye6225.noteapp.services;

import com.amazonaws.auth.DefaultAWSCredentialsProviderChain;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.DeleteObjectRequest;
import com.amazonaws.services.s3.model.ObjectMetadata;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.PostConstruct;
import java.io.IOException;
import java.io.InputStream;

@Service
@Profile("dev")
public class AwsFileHandler implements FileHandler {

    private AmazonS3 s3client;

    private String dir = "Images/";

    @Value("${amazonProperties.endpointUrl}")
    private String endpointUrl;

    @Value("${amazonProperties.bucketName}")
    private String bucketName;

    @PostConstruct
    private void initializeAmazon() {
        this.s3client = AmazonS3ClientBuilder.standard()
                .withCredentials(new DefaultAWSCredentialsProviderChain())
                .build();
    }

    @Override
    public String uploadFile(MultipartFile multipartFile, String emailAddress) throws Exception {
        String fileName = multipartFile.getOriginalFilename().replace(" ", "_");
        String name = this.dir + emailAddress + "/" + fileName;

        InputStream inputStream = null;
        try {
            inputStream = multipartFile.getInputStream();
        } catch (IOException e) {
            e.printStackTrace();
        }

        this.s3client.putObject(bucketName, name, inputStream, new ObjectMetadata());

        return this.endpointUrl + "/" + this.bucketName + "/" + name;
    }

    @Override
    public String deleteFile(String fileLocation) throws Exception {
        String fileName = fileLocation.substring(fileLocation.lastIndexOf("/") + 1);
        s3client.deleteObject(new DeleteObjectRequest(bucketName + "/", fileName));
        return "Successfully deleted";
    }
}
