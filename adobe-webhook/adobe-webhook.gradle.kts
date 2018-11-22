
plugins{
    `java`
}

dependencies {
    implementation("com.amazonaws:aws-lambda-java-core:+")
    implementation("com.amazonaws:aws-lambda-java-events:+")
    implementation("com.amazonaws:aws-lambda-java-log4j2:+")
}

tasks.create<Zip>("buildZip") {
    from(tasks["compileJava"])
    from(tasks["processResources"])
    into("lib"){
        from(configurations["compileClasspath"])
    }
}