# Keep Amplify classes
-keep class com.amplifyframework.** { *; }

# Keep Gson TypeTokens (used internally by DataStore)
-keep class com.google.gson.reflect.TypeToken
-keep class * extends com.google.gson.reflect.TypeToken

# Keep your models
-keepclassmembers class * {
    @com.amplifyframework.core.model.ModelField <fields>;
}

# Optional: keep Amplify plugins
-keep class com.amplifyframework.datastore.** { *; }
-keep class com.amplifyframework.api.** { *; }
-keep class com.amplifyframework.auth.** { *; }
-keep class com.amplifyframework.storage.** { *; }
