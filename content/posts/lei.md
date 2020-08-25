---
title: "lei - a Go installer"
date: 2020-08-25T17:01:58+05:30
draft: true
---

A CLI tool to help install Go, written in Go!

<b>lexicon</b>
><i>lei, language:</em> Manipuri,
 🔉 /pronounciation/
 noun 1. flower</i>

## Overview
A CLI tool to download and install Go. It shall allow selecting from a list of available Go versions and install it.

## Context 
When a new version of Go is released, I have to go through the process of going to golang.org website, download the tarball, extract it, remove current installation, use the extracted new version. This tool aims to automate most of the steps involved.

## Design
### How to get the available Go versions?
Internal implementation for downloading and installing various Go versions.

https://go.googlesource.com/dl/+/d149fc5456ffdf4b7d53e1893ec23f0585d414a0/
internal/version/version.go#381

https://go.googlesource.com/dl/

Snippet from golang.org/dl/internal/version/version.go constructing the URL.

```go
func versionArchiveURL(version string) string {
	goos := getOS()
	// TODO: Maybe we should parse
	// https://storage.googleapis.com/go-builder-data/dl-index.txt ?
	// Let's just guess the URL for now and see if it's there.
	// Then we don't have to maintain that txt file too.
	ext := ".tar.gz"
	if goos == "windows" {
		ext = ".zip"
	}
	arch := runtime.GOARCH
	if goos == "linux" && runtime.GOARCH == "arm" {
		arch = "armv6l"
	}
	return "https://storage.googleapis.com/golang/" + version + "." + goos + "-" + arch + ext
}
```

As mentioned in the comment in the code, https://storage.googleapis.com/go-builder-data/dl-index.txt is a list of download links for various Go versions. It can be parsed and use for providing a list of version numbers to select from.

This process can be used for forming the download for a given Go version.