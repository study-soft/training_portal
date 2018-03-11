package com.company.training_portal.validator;

import com.company.training_portal.model.User;
import com.company.training_portal.model.enums.UserRole;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import java.time.LocalDate;
import java.util.regex.Pattern;

public class UserValidator implements Validator {
    @Override
    public boolean supports(Class<?> clazz) {
        return User.class.isAssignableFrom(clazz);
    }

    @Override
    public void validate(Object target, Errors errors) {
        User user = (User) target;

        validateLogin(user.getLogin(), errors);
        validatePassword(user.getPassword(), errors);
        validateEmail(user.getEmail(), errors);
        validatePhoneNumber(user.getPhoneNumber(), errors);
        validateUserRole(user.getUserRole(), errors);
        validateFirstName(user.getFirstName(), errors);
        validateLastName(user.getLastName(), errors);
        validateDateOfBirth(user.getDateOfBirth(), errors);
    }

    private boolean contains(String string, String regex) {
        return Pattern.compile(regex).matcher(string).find();
    }

    private void validateLogin(String login, Errors errors) {
        if (login == null) {
            errors.rejectValue("login", "user.login.empty");
        } else if (contains(login, "\\s+")) {
            errors.rejectValue("login", "user.login.space");
        } else if (login.length() < 5 || login.length() > 20) {
            errors.rejectValue("login", "user.login.size");
        } else if (!login.matches("\\w+")) {
            errors.rejectValue("login", "user.login.format");
        }
    }

    private void validatePassword(String password, Errors errors) {
        if (password == null) {
            errors.rejectValue("password", "user.password.empty");
        } else if (contains(password, "\\s+")) {
            errors.rejectValue("password", "user.password.space");
        } else if (password.length() < 6 || password.length() > 15) {
            errors.rejectValue("password", "user.password.size");
        } else if (!contains(password, "[0-9]+") || !contains(password, "[a-zA-Z]+")) {
            errors.rejectValue("password", "user.password.format");
        }
    }

    private void validateEmail(String email, Errors errors) {
        if (email == null) {
            errors.rejectValue("email", "user.email.empty");
        } else if (!email.matches("^[\\w\\d._-]+@[\\w\\d.-]+\\.[\\w\\d]{2,6}$")) {
            errors.rejectValue("email", "user.email.format");
        }
    }

    private void validatePhoneNumber(String phoneNumber, Errors errors) {
        if (phoneNumber == null) {
            errors.rejectValue("phoneNumber", "user.phoneNumber.empty");
        } else if (!phoneNumber.matches("\\(?([0-9]{3})\\)?([ .-]?)([0-9]{3})\\2([0-9]{2})\\2([0-9]{2})")) {
            errors.rejectValue("phoneNumber", "user.phoneNumber.format");
        }
    }

    private void validateUserRole(UserRole userRole, Errors errors) {
        if (userRole == null) {
            errors.rejectValue("userRole", "user.userRole.empty");
        } else {
            String role = userRole.getRole();
            if (!role.equals("STUDENT") && !role.equals("TEACHER")) {
                errors.rejectValue("userRole", "user.userRole.format");
            }
        }
    }

    private void validateFirstName(String firstName, Errors errors) {
        if (firstName == null) {
            return;
        } else if (firstName.length() > 40) {
          errors.rejectValue("firstName", "user.firstName.size");
        } else if (!firstName.matches("[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*")) {
            errors.rejectValue("firstName", "user.firstName.format");
        }
    }

    private void validateLastName(String lastName, Errors errors) {
        if (lastName == null) {
            return;
        } else if (lastName.length() > 40) {
            errors.rejectValue("lastName", "user.lastName.size");
        } else if (!lastName.matches("[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*")) {
            errors.rejectValue("lastName", "user.lastName.format");
        }
    }

    private void validateDateOfBirth(LocalDate dateOfBirth, Errors errors) {
        if (dateOfBirth == null) {
            return;
        } else if (dateOfBirth.isAfter(LocalDate.now())) {
            errors.rejectValue("dateOfBirth", "user.dateOfBirth.old");
        } else if (!dateOfBirth.toString().matches("[0-9]{4}-(0[1-9]|1[012])-(0[1-9]|1[0-9]|2[0-9]|3[01])")) {
            errors.rejectValue("dateOfBirth", "user.dateOfBirth.format");
        }
    }
}