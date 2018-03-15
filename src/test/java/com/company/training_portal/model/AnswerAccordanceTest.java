package com.company.training_portal.model;

import org.junit.Before;
import org.junit.Test;

import java.util.HashMap;
import java.util.Map;

import static org.junit.Assert.*;

public class AnswerAccordanceTest {

    private AnswerAccordance answerAccordance;
    private Map<String, String> correctMap;

    @Before
    public void setUp() {
        answerAccordance = new AnswerAccordance.AnswerAccordanceBuilder().build();
        answerAccordance.setQuestionId(1L);
        correctMap = new HashMap<>();
        correctMap.put("leftPart1", "rightPart1");
        correctMap.put("leftPart2", "rightPart2");
        correctMap.put("leftPart3", "rightPart3");
//        answerAccordance.setCorrectMap(correctMap);
    }

    @Test
    public void test_AnswerAccordance_builder() {
        Map<String, String> correctMap = new HashMap<>();
        correctMap.put("leftPart1", "rightPart1");
        correctMap.put("leftPart2", "rightPart2");
        correctMap.put("leftPart3", "rightPart3");
        AnswerAccordance answerAccordanceBuilt = new AnswerAccordance.AnswerAccordanceBuilder()
                .questionId(1L)
//                .correctMap(correctMap)
                .build();
        assertEquals(answerAccordance, answerAccordanceBuilt);
    }

    @Test
    public void test_correctMap() {
        Map<String, String> correctMap = new HashMap<>();
        correctMap.put("leftPart1", "rightPart1");
        correctMap.put("leftPart2", "rightPart2");
        correctMap.put("leftPart3", "rightPart3");
        assertEquals(this.correctMap, correctMap);
    }
}