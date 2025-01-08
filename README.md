# Flutter Humanoid Robot Application

## Description:

This repository holds the source code of Flutter Application for the "Humanoid Robot" project that is configured to work with integration on flutter. It is a part of the project "Enhancing Humanoid Robot Functionality through Vision based Navigation and Object Manipulation" which is a final year project from BEI 077 Batch of Thapathali Campus, IOE, T.U.

# Integration with Unity

## Important Points to consider.

1. The steps mentioned here assumes that you have already setup flutter project and exported the files from unity application in android -> unityLibrary as described in the repo: https://github.com/acharyaSabin11/Unity-Flutter-Humanoid-Robot-Simulation.git (Unity Project for this integration)
2. This project uses "flutter_embed_unity" package for integration.
3. Some files exported from the unity needs to be reconfigured everytime it is exported from the unity. So be cautios on that part.(will mention them later)

## Setup:

1. Run $flutter pub get to load all the dependencies.
2. For simple configuration, you can follow the android setup part of the "flutter_embed_unity" package in pub.dev.(This is already configured when you clone this repository). In short the configuration are:

   a. Add the Unity project as a dependency to your app by adding the following to ${flutter project}/android/app/build.gradle.

   ```groovy
   dependencies {
    implementation project(':unityLibrary')
    }
   ```

   b. Add the exported unity project to the gradle build by including it in ${flutter project}/android/settings.gradle

   ```groovy
   include ':unityLibrary'
   ```

   Make sure not to include this at the top of the gradle file.

   c. Add the Unity export directory as a repository so gradle can find required libraries/AARs etc in ${flutter project}/android/build.gradle

   ```groovy
    allprojects {
        repositories {
            google()
            mavenCentral()
            // Add this:
            flatDir {
                dirs "${project(':unityLibrary').projectDir}/libs"
            }
        }
    }
   ```

   d. Add to android/gradle.properties

   ```
    unityStreamingAssets=
   ```

3. Configure settings specific to this project. (Other things are already setup when cloning the repo, step c should be considered on every export from unity)

   a. In ${flutter_project}/android/app/gradle/wrapper/gradle-wrapper.properties, change the distributionUrl to:

   ```
    distributionUrl=https\://services.gradle.org/distributions/gradle-8.0-all.zip
   ```

   b. In ${flutter_project}/android/app/src/build.gradle, change the following:

   ```
   minSdk = 22
   ```

   c. In ${flutter_project}/android/unityLibrary/build.gradle, comment out the line:

   ```
   dependencies {
    implementation fileTree(dir: 'libs', include: ['*.jar'])
    // implementation project('mobilenotifications.androidlib') this line needs to be commented
    }
   ```

   Note that this line needs to be commented each time the unity exports the file.

   d. In ${flutter_project}/android/settings.gradle, change the com.android.application version to 8.1.0

   ```
   plugins {
    id "dev.flutter.flutter-plugin-loader" version "1.0.0"
    id "com.android.application" version "8.1.0" apply false    //In this line
    id "org.jetbrains.kotlin.android" version "1.7.10" apply false
    }
   ```

4. Rest of the code is already setup in the repository.

## Now the unity is setup.
