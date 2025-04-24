plugins {
    id("org.jetbrains.kotlin.jvm") version "1.9.10"
    id("com.google.protobuf") version "0.9.3"
    id("org.jetbrains.dokka") version "1.9.0" // Optional for documentation
}

version = "1.0.0"

repositories {
    mavenCentral()
    google()
}

dependencies {
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.7.3")
    implementation("io.grpc:grpc-protobuf:1.56.0")
    implementation("io.grpc:grpc-stub:1.56.0")
    implementation("com.google.protobuf:protobuf-kotlin:3.25.5")
    implementation("io.grpc:grpc-kotlin-stub:1.3.0")
    runtimeOnly("io.grpc:grpc-netty:1.56.0")

    testImplementation("org.junit.jupiter:junit-jupiter:5.10.0")
    testImplementation("com.google.truth:truth:1.1.5")
}

protobuf {
    protoc {
        artifact = "com.google.protobuf:protoc:3.25.5"
    }
    plugins {
        create("grpc") {
            artifact = "io.grpc:protoc-gen-grpc-java:1.56.0"
        }
        create("grpckt") {
            artifact = "io.grpc:protoc-gen-grpc-kotlin:1.3.0:jdk8@jar"
        }
    }
    generateProtoTasks {
        all().forEach {
            it.plugins {
                create("grpc")
                create("grpckt")
            }
            it.builtins {
                create("kotlin")
            }
        }
    }
}

sourceSets {
    main {
        proto {
            srcDir("../../proto") // Replace with the relative path to your higher-level directory
        }
    }
}

kotlin {
    sourceSets {
        main {
            kotlin.srcDir("build/generated/source/proto/main/java")
            kotlin.srcDir("build/generated/source/proto/main/kotlin")
        }
    }
}