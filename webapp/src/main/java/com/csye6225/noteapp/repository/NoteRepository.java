package com.csye6225.noteapp.repository;

import com.csye6225.noteapp.models.Note;
import org.springframework.data.repository.CrudRepository;

import java.util.UUID;

public interface NoteRepository extends CrudRepository<Note, Integer> {

    Note findById(String id);
}
