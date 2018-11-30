buildscript {
    repositories {
        mavenCentral()
        jcenter()
    }

    dependencies {
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.3.10")
        classpath("com.github.jengelman.gradle.plugins:shadow:+")
    }
}

repositories {
    mavenCentral()
    jcenter()
}

plugins {
    kotlin("jvm") version "1.3.10"
    idea
}

// This is really annoying, I can't figure out how to get it to run in the
// plugins block. I'll need to loop back on this later when I learn the DSL better.
apply(plugin = "com.github.johnrengelman.shadow")

java {
    sourceCompatibility = JavaVersion.VERSION_1_8
    targetCompatibility = JavaVersion.VERSION_1_8
}

dependencies {
    implementation("com.amazonaws:aws-lambda-java-core:+")
    implementation("com.amazonaws:aws-lambda-java-events:+")
    implementation("com.amazonaws:aws-lambda-java-log4j2:+")
    implementation("com.beust:klaxon:3.0.1")
    compile(kotlin("reflect"))
    compile(kotlin("stdlib-jdk8"))
    compile(kotlin("stdlib"))
}

tasks {
    "build" {
        dependsOn("shadowJar")
    }
}
