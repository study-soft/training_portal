package com.studysoft.trainingportal.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.core.env.MutablePropertySources;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.core.io.support.ResourcePropertySource;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Configuration
public class PropertiesConfiguration {

    private static final String PROPERTIES_PATTERN = "classpath:config/application-%s.properties";
    private static final String COMMON_PROPERTIES_NAME = "config/application.properties";

    @Bean
    public static PropertySourcesPlaceholderConfigurer properties(ConfigurableEnvironment env, ResourceLoader resourceLoader) throws IOException {
        List<Resource> props = new ArrayList<>();
        MutablePropertySources propertySources = env.getPropertySources();
        Resource commonResource = new ClassPathResource(COMMON_PROPERTIES_NAME);
        props.add(commonResource);
        propertySources.addFirst(new ResourcePropertySource(COMMON_PROPERTIES_NAME, commonResource));
        for (String profile : env.getActiveProfiles()) {
            String resourceName = String.format(PROPERTIES_PATTERN, profile);
            Resource resource = resourceLoader.getResource(resourceName);
            if (resource.exists()) {
                props.add(resource);
                propertySources.addAfter(COMMON_PROPERTIES_NAME, new ResourcePropertySource(resourceName.split(":")[1], resource));
            }
        }
        Resource[] resources = props.toArray(new Resource[0]);
        PropertySourcesPlaceholderConfigurer configurer = new PropertySourcesPlaceholderConfigurer();
        configurer.setLocations(resources);
        configurer.setIgnoreUnresolvablePlaceholders(true);
        System.out.println("active props: " + Arrays.toString(resources));
        return configurer;
    }
}
