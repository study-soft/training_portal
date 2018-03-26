package com.company.training_portal.validator;

import com.company.training_portal.model.Quiz;
import org.springframework.stereotype.Service;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import java.util.regex.Pattern;

@Service
public class QuizValidator implements Validator {

    @Override
    public boolean supports(Class<?> clazz) {
        return Quiz.class.isAssignableFrom(clazz);
    }

    @Override
    public void validate(Object target, Errors errors) {
        Quiz quiz = (Quiz) target;
        validateQuizName(quiz.getName(), errors);
        validateDescription(quiz.getDescription(), errors);
        validateExplanation(quiz.getExplanation(), errors);
    }

    private boolean contains(String string, String regex) {
        return Pattern.compile(regex).matcher(string).find();
    }

    public void validateQuizName(String name, Errors errors) {
        if (name == null || name.isEmpty()) {
            errors.rejectValue("name", "quiz.name.empty");
        } else if (name.length() > 50) {
            errors.rejectValue("name", "quiz.name.size");
        } else if (contains(name, "[<>]+")) {
            errors.rejectValue("name", "quiz.name.format");
        }
    }

    public void validateDescription(String description, Errors errors) {
        if (description == null) {
            return;
        } else if (description.length() > 65535) {
            errors.rejectValue("description", "quiz.description.size");
        } else if (contains(description, "[<>]+")) {
            errors.rejectValue("description", "quiz.description.format");
        }
    }

    public void validateExplanation(String explanation, Errors errors) {
        if (explanation == null) {
            return;
        } else if (explanation.length() > 65535) {
            errors.rejectValue("explanation", "quiz.explanation.size");
        } else if (contains(explanation, "[<>]+")) {
            errors.rejectValue("explanation", "quiz.explanation.format");
        }
    }

    public void validateHours(String hours, Errors errors) {

    }

    public void validateMinutes(String minutes, Errors errors) {

    }

    public void validateSeconds(String seconds, Errors errors) {

    }
}
