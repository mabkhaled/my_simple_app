// Project-level build.gradle.kts

allprojects {
    repositories {
        google()  // Google's Maven repository for Android libraries
        mavenCentral()  // Central Maven repository for other dependencies
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

// Adjust build directories for subprojects
subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Ensures that the clean task deletes the root project's build directory
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
buildscript {
    repositories {
        google()  // Make sure this is included
        mavenCentral()
    }
    dependencies {
        classpath="com.android.tools.build:gradle:7.2.1" // Gradle version
        classpath="com.google.gms:google-services:4.3.10"  // This is the Firebase plugin version
    }
}

