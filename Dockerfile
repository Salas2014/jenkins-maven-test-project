FROM openjdk:8
COPY jarstaging/com/salas/demo-workshop/2.1.2/demo-workshop-2.1.2.jar salas-workshop.jar
ENV SPRING_PROFILES_ACTIVE=standalone
ENTRYPOINT ["java", "-jar", "--spring.profiles.active=${SPRING_PROFILES_ACTIVE}", "salas-workshop.jar"]