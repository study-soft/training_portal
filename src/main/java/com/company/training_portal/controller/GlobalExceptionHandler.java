package com.company.training_portal.controller;

import org.apache.log4j.Logger;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class GlobalExceptionHandler /*extends ResponseEntityExceptionHandler*/ {

    private static final Logger logger = Logger.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler
    public String handleException(Exception exception, Model model) {
        if (exception instanceof AccessDeniedException) {
            logger.warn("Access denied");
            return "error/access-denied";
        } else if (exception instanceof EmptyResultDataAccessException) {
            logger.warn("No data found");
            return "error/no-data-found";
        } else {
            model.addAttribute("exception", exception);
            return "error/exception";
        }
    }
}
