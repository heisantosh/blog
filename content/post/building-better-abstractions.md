---
title: "Building Better Abstractions"
date: 2026-01-10T09:15:00+05:30
draft: false
description: "What makes the difference between good and bad abstractions."
tags: ["software-design", "philosophy"]
---

> AI generated to act as place holder for my blog post!

Good abstractions are invisible. Bad abstractions are constant friction. After building and maintaining software for a while, I've developed some intuitions about what makes the difference.

## The Leaky Abstraction Problem

Joel Spolsky coined "The Law of Leaky Abstractions" - all non-trivial abstractions leak. But some leak less than others. The goal isn't perfection; it's minimizing how often users need to understand the underlying implementation.

A good test: can someone use your abstraction effectively without reading the source code?

## Start Concrete, Abstract Later

The most common mistake I see (and make) is abstracting too early. You see two similar pieces of code and immediately want to DRY them up. But premature abstraction often leads to:

- Interfaces that don't quite fit either use case
- Abstractions that need to be worked around
- Code that's harder to understand than the duplication would be

I now wait until I have at least three concrete examples before creating an abstraction. By then, the pattern is clearer.

## Good Abstractions Have Clear Boundaries

The best abstractions create a clean separation between "inside" and "outside." Users of the abstraction shouldn't need to know or care about internal details.

```go
// Clear boundary - users don't need to know how caching works
cache := NewCache(WithTTL(time.Hour))
cache.Set("key", value)
value, ok := cache.Get("key")

// Leaky boundary - implementation details exposed
cache := NewCache()
cache.SetWithEvictionPolicy("key", value, LRUEviction, time.Hour)
```

## Naming Matters More Than You Think

A good name communicates intent and sets expectations. If you're struggling to name something, that's often a sign the abstraction isn't quite right.

`ProcessData` tells me nothing. `ValidateAndStoreUserProfile` tells me exactly what to expect.

## Design for the Common Case

Your abstraction should make the common case easy and the uncommon case possible. Don't complicate the simple path to support edge cases that rarely occur.

This often means:

- Sensible defaults that work for 80% of use cases
- Optional configuration for the other 20%
- Escape hatches for the truly unusual

## Conclusion

Building good abstractions is hard and takes practice. Be patient with yourself, iterate on your designs, and don't be afraid to throw away abstractions that aren't working. The code will thank you later.
