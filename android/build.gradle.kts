// android/build.gradle.kts (project-level)
import org.gradle.api.tasks.Delete

buildscript {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
    dependencies {
        // Android Gradle Plugin
        classpath("com.android.tools.build:gradle:7.3.1")

        // Kotlin Gradle plugin (required when using id("kotlin-android") in app module)
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.8.22")

        // Google services plugin
        classpath("com.google.gms:google-services:4.3.15")
    }
}

plugins {
    // Keep this block minimal — app module has its own plugins block
    // (No need to add com.google.gms here)
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// keep any custom build dir changes you previously had
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
