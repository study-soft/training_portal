package com.company.training_portal.validator;

import com.company.training_portal.model.User;
import com.company.training_portal.model.enums.UserRole;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import java.time.LocalDate;
import java.util.regex.Pattern;

@Service
@PropertySource("classpath:validationMessages.properties")
public class UserValidator implements Validator {

    private Environment environment;

    @Autowired
    public UserValidator(Environment environment) {
        this.environment = environment;
    }

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

    public void validateLogin(String login, Errors errors) {
        if (login == null || login.isEmpty()) {
            errors.rejectValue("login", "user.login.empty");
        } else if (contains(login, "\\s+")) {
            errors.rejectValue("login", "user.login.space");
        } else if (login.length() < 5 || login.length() > 20) {
            errors.rejectValue("login", "user.login.size");
        } else if (!login.matches("\\w+")) {
            errors.rejectValue("login", "user.login.format");
        }
    }

    public void validatePassword(String password, Errors errors) {
        if (password == null || password.isEmpty()) {
            errors.rejectValue("password", "user.password.empty");
        } else if (contains(password, "\\s+")) {
            errors.rejectValue("password", "user.password.space");
        } else if (password.length() < 6 || password.length() > 15) {
            errors.rejectValue("password", "user.password.size");
        } else if (!contains(password, "[0-9]+") || !contains(password, "[a-zA-Z]+")) {
            errors.rejectValue("password", "user.password.format");
        }
    }

    public String validateNewPassword(String newPassword) {
        String error = null;
        if (newPassword == null || newPassword.isEmpty()) {
            error = environment.getProperty("user.password.empty");
        } else if (contains(newPassword, "\\s+")) {
            error = environment.getProperty("password", "user.password.space");
        } else if (newPassword.length() < 6) {
            error = environment.getProperty("user.password.size");
        } else if (!contains(newPassword, "[0-9]+") || !contains(newPassword, "[a-zA-Z]+")) {
            error = environment.getProperty("user.password.format");
        }
        return error;
    }

    public void validateEmail(String email, Errors errors) {
        if (email == null || email.isEmpty()) {
            errors.rejectValue("email", "user.email.empty");
        } else if (!email.matches("^[\\w\\d._-]+@[\\w\\d.-]+\\.[\\w\\d]{2,6}$")) {
            errors.rejectValue("email", "user.email.format");
        }
    }

    public void validatePhoneNumber(String phoneNumber, Errors errors) {
        if (phoneNumber == null || phoneNumber.isEmpty()) {
            errors.rejectValue("phoneNumber", "user.phoneNumber.empty");
        } else if (!phoneNumber.matches("\\(?([0-9]{3})\\)?([ -]?)([0-9]{3})\\2([0-9]{2})\\2([0-9]{2})")) {
            errors.rejectValue("phoneNumber", "user.phoneNumber.format");
        }
    }

    public void validateUserRole(UserRole userRole, Errors errors) {
        if (userRole == null || userRole.getRole().isEmpty()) {
            errors.rejectValue("userRole", "user.userRole.empty");
        } else {
            String role = userRole.getRole();
            if (!role.equals("STUDENT") && !role.equals("TEACHER")) {
                errors.rejectValue("userRole", "user.userRole.format");
            }
        }
    }

    public void validateFirstName(String firstName, Errors errors) {
        if (firstName == null) {
            return;
        } else if (firstName.length() > 40) {
          errors.rejectValue("firstName", "user.firstName.size");
        } else if (!firstName.matches("[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*")) {
            errors.rejectValue("firstName", "user.firstName.format");
        }
    }

    public void validateLastName(String lastName, Errors errors) {
        if (lastName == null) {
            return;
        } else if (lastName.length() > 40) {
            errors.rejectValue("lastName", "user.lastName.size");
        } else if (!lastName.matches("[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*")) {
            errors.rejectValue("lastName", "user.lastName.format");
        }
    }

    public void validateDateOfBirth(LocalDate dateOfBirth, Errors errors) {
        if (dateOfBirth == null) {
            return;
        } else if (dateOfBirth.isAfter(LocalDate.now())) {
            errors.rejectValue("dateOfBirth", "user.dateOfBirth.old");
        } else if (!dateOfBirth.toString().matches("[0-9]{4}-(0[1-9]|1[012])-(0[1-9]|1[0-9]|2[0-9]|3[01])")) {
            errors.rejectValue("dateOfBirth", "user.dateOfBirth.format");
        }
    }
}