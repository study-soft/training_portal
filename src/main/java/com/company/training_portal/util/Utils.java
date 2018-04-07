package com.company.training_portal.util;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.List;

import static java.time.format.FormatStyle.MEDIUM;
import static java.time.format.FormatStyle.SHORT;

public class Utils {

    // Prevent creation of instances
    private Utils() {
        throw new AssertionError();
    }

    public static int roundOff(double value) {
        return (value * 10) % 10 >= 5 ? (int) value + 1 : (int) value;
    }

    public static List<Integer> durationToTimeUnits(Duration duration) {
        if (duration == null) {
            return null;
        }
        long seconds = duration.toSeconds();
        int effectiveSeconds = (int) seconds % 60;
        int minutes = (int) seconds / 60;
        int effectiveMinutes = minutes % 60;
        int hours = minutes / 60;
        return Arrays.asList(hours, effectiveMinutes, effectiveSeconds);
    }

    public static Duration timeUnitsToDuration(int hours, int minutes, int seconds) {
        long totalSeconds = seconds + minutes * 60 + hours * 3600;
        return Duration.ofSeconds(totalSeconds);
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

    public static String formatPhoneNumber(String target) {
        String digits = target.replaceAll("\\D", "");
//        String digits = Pattern.compile("[\\D]")
//                .splitAsStream(target)
//                .collect(Collectors.joining());
        return "(" +
                digits.substring(0, 3) +
                ")-" +
                digits.substring(3, 6) +
                "-" +
                digits.substring(6, 8) +
                "-" +
                digits.substring(8, 10);
    }
}
