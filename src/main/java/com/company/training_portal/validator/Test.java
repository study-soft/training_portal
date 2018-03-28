package com.company.training_portal.validator;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Test {
    public static void main(String[] args) {
        String str = "correct0";
        String str1 = "correct1";
        String str2 = "correct2";
        List<String> strings = Arrays.asList("correct0", "correct1",
                "correct2", "abc", "correct3", "xyz", "mnk");
        for (String string : strings) {
            if (string.contains("correct")) {
                System.out.println(string);
            }
        }
    }
}
