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

