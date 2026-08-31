// This file contains the fixes for HomeViewModel.kt compilation errors
// Replace lines 145-155 with the corrected code below:

// FIXED VERSION - Lines 145-155:
// Change all instances of emptySet() to emptyList() for List type parameters

// Line 148 - FROM:
// val consoles = emptySet<ConsoleEntity>()
// TO:
val consoles = emptyList<ConsoleEntity>()

// Line 151 - FROM:
// val consolesWithCount = emptySet<ConsoleWithFileCount>()
// TO:
val consolesWithCount = emptyList<ConsoleWithFileCount>()

// The issue is that emptySet() returns Set<T> but the functions expect List<T>
// Always use emptyList() for List parameters and emptySet() for Set parameters
