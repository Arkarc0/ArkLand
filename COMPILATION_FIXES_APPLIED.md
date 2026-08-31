# Compilation Fixes Applied

This document outlines the fixes that need to be applied to the Kotlin source files to resolve the build errors.

## Files to Fix

### 1. ArchiveScraper.kt
Location: `dogmatix/app/src/main/java/com/cortinadev/dogmatix/provider/ArchiveScraper.kt`

**Line 69 - Add explicit type annotation:**
```kotlin
// BEFORE:
list.forEach { element ->

// AFTER:
list.forEach { element: com.google.gson.JsonElement ->
```

**Line 133 - Verify JsonHttp import:**
Ensure this import exists at the top of the file:
```kotlin
import com.cortinadev.dogmatix.provider.JsonHttp
```
or if using Gson directly:
```kotlin
import com.google.gson.*
```

**Line 147 - Fix ambiguous iterator() call:**
```kotlin
// BEFORE:
for (item in enumeration) { ... }

// AFTER:
for (item in enumeration.iterator()) { ... }
// OR
for (item in enumeration.toList()) { ... }
```

### 2. HomeViewModel.kt
Location: `dogmatix/app/src/main/java/com/cortinadev/dogmatix/ui/screens/home/HomeViewModel.kt`

**Line 148 - Replace emptySet() with emptyList():**
```kotlin
// BEFORE:
...emptySet<ConsoleEntity>()...

// AFTER:
...emptyList<ConsoleEntity>()...
```

**Line 151 - Replace emptySet() with emptyList():**
```kotlin
// BEFORE:
...emptySet<ConsoleWithFileCount>()...

// AFTER:
...emptyList<ConsoleWithFileCount>()...
```

## Summary of Issues

1. **Type Inference**: Lambda parameter needs explicit type when Kotlin cannot infer it
2. **Missing Imports**: JsonHttp or Gson imports missing
3. **Type Mismatch**: Using `emptySet()` (returns Set<T>) where `emptyList()` (returns List<T>) is expected
4. **Ambiguous Method**: Multiple iterator() implementations available, must specify explicitly

## Next Steps

1. Extract `dogmatix-export.zip`
2. Apply the fixes above to the respective Kotlin files
3. Repackage as `dogmatix-export.zip`
4. Commit and push the changes
5. Re-run the GitHub Actions workflow
