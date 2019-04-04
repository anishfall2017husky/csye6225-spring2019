package com.csye6225.noteapp.repository;

import com.csye6225.noteapp.models.Note;
import org.springframework.data.repository.CrudRepository;

import javax.transaction.Transactional;

@Transactional
public interface NoteRepository extends CrudRepository<Note, Integer> {

    Note findById(String id);

    int deleteNoteById(String id);
}
