# Keep Media3 (modern ExoPlayer)
-keep class androidx.media3.** { *; }
-dontwarn androidx.media3.**

# Keep older ExoPlayer (some devices / dependencies still reference it)
-keep class com.google.android.exoplayer2.** { *; }
-dontwarn com.google.android.exoplayer2.**

# Keep audio decoders
-keep class androidx.media3.exoplayer.audio.** { *; }
-keep class androidx.media3.exoplayer.decoder.** { *; }
