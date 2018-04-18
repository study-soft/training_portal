package com.company.training_portal.controller;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class GlobalExceptionHandler /*extends ResponseEntityExceptionHandler*/ {

    @ExceptionHandler
    public String handleException(Exception exception, Model model) {
        model.addAttribute("exception", exception);
        return "exception";
    }
}
