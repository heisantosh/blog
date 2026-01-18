---
title: "Understanding Go Context"
date: 2026-01-18T10:00:00+05:30
draft: false
description: "A deep dive into Go's context package for cancellation and timeouts."
tags: ["go", "concurrency", "programming"]
---

> AI generated to act as place holder for my blog post!

The `context` package in Go is one of those features that seems simple at first but reveals its depth as you work with it more. It's become essential for writing robust, concurrent Go programs.

## What Problem Does Context Solve?

When you're building services, you often need to:

1. **Cancel operations** when a request times out
2. **Pass request-scoped values** through your call chain
3. **Set deadlines** for operations

Before context, developers passed around cancellation channels and deadline values manually. Context standardizes this.

## The Basics

Here's a simple example of context in action:

```go
func fetchData(ctx context.Context) ([]byte, error) {
    req, err := http.NewRequestWithContext(ctx, "GET", "https://api.example.com/data", nil)
    if err != nil {
        return nil, err
    }
    
    resp, err := http.DefaultClient.Do(req)
    if err != nil {
        return nil, err
    }
    defer resp.Body.Close()
    
    return io.ReadAll(resp.Body)
}
```

The request will automatically be cancelled if the context is cancelled.

## Context Patterns I Use

### Always Pass Context First

By convention, context is always the first parameter:

```go
func ProcessOrder(ctx context.Context, orderID string) error {
    // ...
}
```

### Don't Store Context in Structs

Context should flow through your program, not be stored:

```go
// Bad
type Server struct {
    ctx context.Context
}

// Good
func (s *Server) HandleRequest(ctx context.Context) {
    // ...
}
```

### Use WithTimeout for External Calls

```go
ctx, cancel := context.WithTimeout(parentCtx, 5*time.Second)
defer cancel() // Always defer cancel

result, err := externalService.Call(ctx)
```

## When Context Gets Cancelled

Understanding cancellation is crucial. When a context is cancelled:

1. `ctx.Done()` channel closes
2. `ctx.Err()` returns the reason (cancelled or deadline exceeded)
3. All derived contexts are also cancelled

This cascading behavior is what makes context so powerful for managing complex request lifecycles.

## Conclusion

Context is deceptively simple but incredibly useful. Start with the basics: pass it through your functions, use it for timeouts, and respect cancellation. As your systems grow, you'll appreciate having this standardized approach to request lifecycle management.
