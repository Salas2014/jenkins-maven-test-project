FROM openjdk:8
COPY jarstaging/com/salas/demo-workshop/2.1.2/demo-workshop-2.1.2.jar salas-workshop.jar
ENTRYPOINT ["java", "-jar", "salas-workshop.jar"]