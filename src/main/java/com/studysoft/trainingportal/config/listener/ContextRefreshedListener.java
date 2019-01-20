package com.studysoft.trainingportal.config.listener;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.context.event.EventListener;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Component;

import java.util.Arrays;

@Component
public class ContextRefreshedListener {

    private static final Logger log = Logger.getLogger(ContextRefreshedListener.class);

    @EventListener(condition = "#event.applicationContext.displayName == 'Root WebApplicationContext'")
    public void onContextRefreshed(ContextRefreshedEvent event) {
        ApplicationContext context = event.getApplicationContext();
        Environment env = context.getEnvironment();
        log.info("Context with name = '" + context.getDisplayName() + "' successfully initialized");
        log.info("Active profiles: " + Arrays.toString(env.getActiveProfiles()));
    }
}
