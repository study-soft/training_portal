package com.studysoft.trainingportal.validator;

import com.studysoft.trainingportal.model.Group;
import org.springframework.stereotype.Service;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

@Service
public class GroupValidator implements Validator {

    @Override
    public boolean supports(Class<?> clazz) {
        return Group.class.isAssignableFrom(clazz);
    }

    @Override
    public void validate(Object target, Errors errors) {
        Group group = (Group) target;
        validateName(group.getName(), errors);
        validateDescription(group.getDescription(), errors);
    }

    private void validateName(String name, Errors errors) {
        if (name == null || name.isEmpty()) {
            errors.rejectValue("name", "validation.group.name.empty");
        } else if (name.length() > 255) {
            errors.rejectValue("name", "validation.group.name.size");
        }
    }

    private void validateDescription(String description, Errors errors) {
        if (description == null) {
            return;
        } else if (description.length() > 65534) {
            errors.rejectValue("description", "validation.group.description.size");
        }
    }
}
