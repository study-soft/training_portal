package com.company.training_portal.util;

import java.time.Duration;
import java.util.Arrays;
import java.util.List;

public class Utils {

    public static int roundOff(double value) {
        return (value * 10) % 10 >= 5 ? (int) value + 1 : (int) value;
    }

    public static List<Integer> durationToTimeUnits(Duration duration) {
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
}
