package com.company.training_portal.util;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import static java.time.format.FormatStyle.MEDIUM;
import static java.time.format.FormatStyle.SHORT;

public class Formatter {
    public static String formatDate(LocalDate localDate) {
        DateTimeFormatter dateTimeFormatter =
                DateTimeFormatter.ofLocalizedDate(MEDIUM);
        return localDate.format(dateTimeFormatter);
    }

    public static String formatDateTime(LocalDateTime localDateTime) {
        DateTimeFormatter dateTimeFormatter =
                DateTimeFormatter.ofLocalizedDateTime(MEDIUM, SHORT);
        return localDateTime.format(dateTimeFormatter);
    }

    public static String formatDuration(Duration duration) {
        StringBuilder result = new StringBuilder();
        long totalSeconds = duration.toSeconds();
        int seconds = (int) totalSeconds % 60;
        int totalMinutes = (int) totalSeconds / 60;
        int minutes = totalMinutes % 60;
        int hours = totalMinutes / 60;
        result.append(hours == 0 ? "" : hours + ":")
                .append(minutes < 10 ? "0" : "")
                .append(minutes)
                .append(seconds < 10 ? ":0" : ":")
                .append(seconds);
        return result.toString();
    }
}
