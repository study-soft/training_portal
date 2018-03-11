package com.company.training_portal.model;

import java.time.LocalDate;

public class Group {

    private Long groupId;
    private String name;
    private String description;
    private LocalDate creationDate;
    private Long authorId;

    private Group(GroupBuilder builder) {
        this.groupId = builder.groupId;
        this.name = builder.name;
        this.description = builder.description;
        this.creationDate = builder.creationDate;
        this.authorId = builder.authorId;
    }

    public Group() {
    }

    public Long getGroupId() {
        return groupId;
    }

    public void setGroupId(Long groupId) {
        this.groupId = groupId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDate getCreationDate() {
        return creationDate;
    }

    public void setCreationDate(LocalDate creationDate) {
        this.creationDate = creationDate;
    }

    public Long getAuthorId() {
        return authorId;
    }

    public void setAuthorId(Long authorId) {
        this.authorId = authorId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Group group = (Group) o;

        if (!groupId.equals(group.groupId)) return false;
        if (!name.equals(group.name)) return false;
        if (description != null ? !description.equals(group.description) : group.description != null) return false;
        if (!creationDate.equals(group.creationDate)) return false;
        return authorId.equals(group.authorId);
    }

    @Override
    public int hashCode() {
        int result = groupId.hashCode();
        result = 31 * result + name.hashCode();
        result = 31 * result + (description != null ? description.hashCode() : 0);
        result = 31 * result + creationDate.hashCode();
        result = 31 * result + authorId.hashCode();
        return result;
    }

    @Override
    public String toString() {
        return "Group{" +
                "groupId=" + groupId +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                ", creationDate=" + creationDate +
                ", authorId=" + authorId +
                '}';
    }

    public static final class GroupBuilder {

        private Long groupId;
        private String name;
        private String description;
        private LocalDate creationDate;
        private Long authorId;

        public GroupBuilder() {
        }

        public GroupBuilder groupId(Long groupId) {
            this.groupId = groupId;
            return this;
        }

        public GroupBuilder name(String name) {
            this.name = name;
            return this;
        }

        public GroupBuilder description(String description) {
            this.description = description;
            return this;
        }

        public GroupBuilder creationDate(LocalDate creationDate) {
            this.creationDate = creationDate;
            return this;
        }

        public GroupBuilder authorId(Long authorId) {
            this.authorId = authorId;
            return this;
        }

        public Group build() {
            return new Group(this);
        }
    }
}