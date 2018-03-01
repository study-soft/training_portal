package com.company.training_portal.model;

import java.time.LocalDate;

public class Group {

    private Long groupId;
    private String name;
    private String description;
    private LocalDate creationDate;

    private Group(GroupBuilder builder) {
        this.groupId = builder.groupId;
        this.name = builder.name;
        this.description = builder.description;
        this.creationDate = builder.creationDate;
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

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Group group = (Group) o;

        if (groupId != null ? !groupId.equals(group.groupId) : group.groupId != null) return false;
        if (name != null ? !name.equals(group.name) : group.name != null) return false;
        if (description != null ? !description.equals(group.description) : group.description != null) return false;
        return creationDate != null ? creationDate.equals(group.creationDate) : group.creationDate == null;
    }

    @Override
    public int hashCode() {
        int result = groupId != null ? groupId.hashCode() : 0;
        result = 31 * result + (name != null ? name.hashCode() : 0);
        result = 31 * result + (description != null ? description.hashCode() : 0);
        result = 31 * result + (creationDate != null ? creationDate.hashCode() : 0);
        return result;
    }

    @Override
    public String toString() {
        return "Group{" +
                "groupId=" + groupId +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                ", creationDate=" + creationDate +
                '}';
    }

    public static final class GroupBuilder {

        private Long groupId;
        private String name;
        private String description;
        private LocalDate creationDate;

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

        public Group build() {
            return new Group(this);
        }
    }
}