package com.csye6225.noteapp.models;

import com.google.gson.annotations.Expose;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "note")
public class Note {

    @Id
    @Column(name = "note_id")
    @Expose
    private String id;

    @Column(name = "content")
    @Expose
    private String content;

    @Column(name = "title")
    @Expose
    private String title;

    @Column(name = "created_on")
    @Expose
    private String created_on;

    @Column(name = "last_updated_on")
    @Expose
    private String last_updated_on;

    @ManyToOne(fetch = FetchType.LAZY, cascade = {CascadeType.DETACH,CascadeType.MERGE,CascadeType.PERSIST,CascadeType.REFRESH})
    @JoinColumn(name="user_id")
    private User user;

    public Note () {

    }

    public Note(String content, String title, String created_on, String last_updated_on) {
        this.content = content;
        this.title = title;
        this.created_on = created_on;
        this.last_updated_on = last_updated_on;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getCreated_on() {
        return created_on;
    }

    public void setCreated_on(String created_on) {
        this.created_on = created_on;
    }

    public String getLast_updated_on() {
        return last_updated_on;
    }

    public void setLast_updated_on(String last_updated_on) {
        this.last_updated_on = last_updated_on;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}
