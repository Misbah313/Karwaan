plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.karwaan_flutter"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.karwaan_flutter"
        minSdk = 21
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // ADD THIS CONFIGURATION BLOCK
    configurations.all {
        resolutionStrategy {
            force("androidx.credentials:credentials:1.2.0")
            force("androidx.credentials:credentials-play-services-auth:1.2.0")
            force("com.google.android.libraries.identity.googleid:googleid:1.1.0")
            force("com.google.android.gms:play-services-auth:20.7.0")
            force("androidx.media3:media3-exoplayer:1.2.1")
            force("androidx.media3:media3-exoplayer-hls:1.2.1")
            force("androidx.media3:media3-exoplayer-dash:1.2.1")
            force("androidx.media3:media3-exoplayer-rtsp:1.2.1")
            force("androidx.media3:media3-exoplayer-smoothstreaming:1.2.1")
        }
    }
}

flutter {
    source = "../.."
}

// ADD THESE DEPENDENCIES
dependencies {
    implementation("androidx.credentials:credentials:1.2.0")
    implementation("androidx.credentials:credentials-play-services-auth:1.2.0")
    implementation("com.google.android.libraries.identity.googleid:googleid:1.1.0")
    implementation("com.google.android.gms:play-services-auth:20.7.0")
    implementation("androidx.media3:media3-exoplayer:1.2.1")
    implementation("androidx.media3:media3-exoplayer-hls:1.2.1")
    implementation("androidx.media3:media3-exoplayer-dash:1.2.1")
    implementation("androidx.media3:media3-exoplayer-rtsp:1.2.1")
    implementation("androidx.media3:media3-exoplayer-smoothstreaming:1.2.1")
}