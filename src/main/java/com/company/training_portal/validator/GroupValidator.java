package com.company.training_portal.validator;

import com.company.training_portal.model.Group;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import java.util.regex.Pattern;

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

    private boolean contains(String string, String regex) {
        return Pattern.compile(regex).matcher(string).find();
    }

    private void validateName(String name, Errors errors) {
        if (name == null || name.isEmpty()) {
            errors.rejectValue("name", "group.name.empty");
        } else if (name.length() > 255) {
            errors.rejectValue("name", "group.name.size");
        } else if (contains(name, "[<>]+")) {
            errors.rejectValue("description", "group.description.format");
        }
    }

    private void validateDescription(String description, Errors errors) {
        if (description == null) {
            return;
        } else if (description.length() > 65534) {
            errors.rejectValue("description", "group.description.size");
        } else if (contains(description, "[<>]+")) {
            errors.rejectValue("description", "group.description.format");
        }
    }
}
