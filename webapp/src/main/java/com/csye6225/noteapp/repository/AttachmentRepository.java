package com.csye6225.noteapp.repository;

import com.csye6225.noteapp.models.Attachment;
import org.springframework.data.repository.CrudRepository;

import javax.transaction.Transactional;

public interface AttachmentRepository extends CrudRepository<Attachment, Integer> {

    Attachment findById(String id);

    @Transactional
    int deleteAttachmentById(String id);
}
