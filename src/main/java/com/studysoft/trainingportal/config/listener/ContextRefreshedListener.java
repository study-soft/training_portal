package com.studysoft.trainingportal.config.listener;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.context.event.EventListener;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.Arrays;

@Component
public class ContextRefreshedListener {

    private static final Logger log = Logger.getLogger(ContextRefreshedListener.class);

    @EventListener(condition = "#event.applicationContext.displayName == 'Root WebApplicationContext'")
    public void onContextRefreshed(ContextRefreshedEvent event) {
        ApplicationContext context = event.getApplicationContext();
        Environment env = context.getEnvironment();
        logApplicationStartup(env);
    }

    private static void logApplicationStartup(Environment env) {
        String protocol = "http";
        if (env.getProperty("server.ssl.key-store") != null) {
            protocol = "https";
        }
        String serverPort = env.getProperty("server.port");
        String contextPath = env.getProperty("server.servlet.context-path");
        if (contextPath == null || contextPath.isEmpty()) {
            contextPath = "/";
        }
        String hostAddress = "localhost";
        try {
            hostAddress = InetAddress.getLocalHost().getHostAddress();
        } catch (UnknownHostException e) {
            log.warn("The host name could not be determined, using `localhost` as fallback");
        }
        log.info(String.format("\n----------------------------------------------------------\n\t" +
                        "Application '%s' is running! Access URLs:\n\t" +
                        "Local: \t\t%s://localhost:%s%s\n\t" +
                        "External: \t%s://%s:%s%s\n\t" +
                        "Profile(s): \t%s\n----------------------------------------------------------",
                env.getProperty("spring.application.name"),
                protocol,
                serverPort,
                contextPath,
                protocol,
                hostAddress,
                serverPort,
                contextPath,
                Arrays.toString(env.getActiveProfiles())));
    }
}
