package com.studysoft.trainingportal.util;

import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.util.StringUtils;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.ResourceBundle;

import static java.time.format.FormatStyle.MEDIUM;
import static java.time.format.FormatStyle.SHORT;

public final class Utils {

    private static String DATE_PATTERN = "dd MMM yyyy";
    private static String TIME_PATTERN = "HH:mm:ss";
    private static String DATE_TIME_PATTERN = DATE_PATTERN + " " + TIME_PATTERN;

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
        long seconds = duration.toMillis() / 1000;
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
        long totalSeconds = duration.toMillis() / 1000;
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
        Locale locale = LocaleContextHolder.getLocale();
        return localDate.format(DateTimeFormatter.ofPattern(DATE_PATTERN, locale));
    }

    public static String formatDateTime(LocalDateTime localDateTime) {
        Locale locale = LocaleContextHolder.getLocale();
        return localDateTime.format(DateTimeFormatter.ofPattern(DATE_TIME_PATTERN, locale));
    }

    public static String formatPhoneNumber(String target) {
        String digits = target.replaceAll("\\D", "");
        return "(" +
                digits.substring(0, 3) +
                ")-" +
                digits.substring(3, 6) +
                "-" +
                digits.substring(6, 8) +
                "-" +
                digits.substring(8, 10);
    }

    /**
     * Mask password with pattern x*****x. For example, 123qwe will be masked like 1****e
     *
     * @param password password
     * @return masked password
     */
    public static String maskPassword(String password) {
        if (StringUtils.isEmpty(password)) {
            return "";
        }
        String masked = new String(password.chars().map(ch -> 42).toArray(), 2, password.length() - 2);
        return password.substring(0, 1) + masked + password.substring(password.length() - 1);
    }
}
