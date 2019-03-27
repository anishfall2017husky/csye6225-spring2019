package com.csye6225.noteapp.services;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.csye6225.noteapp.models.Attachment;
import com.csye6225.noteapp.models.Note;
import com.csye6225.noteapp.models.User;
import com.csye6225.noteapp.repository.UserRepository;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.amazonaws.services.sns.AmazonSNSAsync;
import com.amazonaws.services.sns.model.PublishRequest;
import com.amazonaws.services.sns.model.PublishResult;
import com.amazonaws.services.sns.model.Topic;

import javax.servlet.http.HttpServletRequest;
import java.nio.charset.Charset;
import java.util.Base64;
import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.FutureTask;

import javax.annotation.PostConstruct;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.amazonaws.services.sns.AmazonSNSAsync;
import com.amazonaws.services.sns.AmazonSNSAsyncClientBuilder;
import com.amazonaws.services.sns.model.PublishRequest;
import com.amazonaws.services.sns.model.PublishResult;
import com.amazonaws.services.sns.model.Topic;

@Service("userService")
public class UserService {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    private AmazonSNSAsync amazonSNSClient;

    @Autowired
    private UserRepository userRepository;

    @PostConstruct
  	public void initializeSNSClient() {

  		this.amazonSNSClient = AmazonSNSAsyncClientBuilder.defaultClient();
  	}


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
    
    public void getJsonArray(Note n, JsonObject obj) {
        List<Attachment> attachments = n.getAttachments();


        JsonArray filesArray = new JsonArray();

        for (Attachment a  : attachments) {
            JsonObject fileObj = new JsonObject();
            fileObj.addProperty("id",a.getId());
            fileObj.addProperty("url",a.getUrl());
            filesArray.add(fileObj);
        }

        obj.add("attachments",filesArray);
    }

    public void sendMessage(String emailId) throws ExecutionException, InterruptedException {

      logger.info("Sending Message - {} ", emailId);

      String topicArn = getTopicArn("password_reset");
      PublishRequest publishRequest = new PublishRequest(topicArn, emailId);
      Future<PublishResult> publishResultFuture = amazonSNSClient.publishAsync(publishRequest);
      String messageId = publishResultFuture.get().getMessageId();

      logger.info("Send Message {} with message Id {} ", emailId, messageId);

    }

    public String getTopicArn(String topicName) {

		String topicArn = null;

		try {
			Topic topic = amazonSNSClient.listTopicsAsync().get().getTopics().stream()
					.filter(t -> t.getTopicArn().contains(topicName)).findAny().orElse(null);

			if (null != topic) {
				topicArn = topic.getTopicArn();
			} else {
				logger.info("No Topic found by the name : ", topicName);
			}

		} catch (InterruptedException e) {
			e.printStackTrace();
		} catch (ExecutionException e) {
			e.printStackTrace();
		}

		logger.info("Arn corresponding to topic name {} is {} ", topicName, topicArn);

		return topicArn;

	}



}
