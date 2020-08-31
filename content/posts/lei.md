---
title: "lei - a Go installer"
date: 2020-08-25T17:01:58+05:30
draft: false
---

A CLI tool to help install Go, written in Go!
or that's what I wanted to create!

><b>lexicon</b><br>
<i>word: lei, language:</em> Manipuri, noun 1. flower</i>

Whenever a new version of Go is released I have to download the tarball, extract it and replace the current installation. Usually I typed some commands in the command line to accomplish the task. I could use a shell script to accomplish it. There are already some tools which can install Go and even manage different versions and installations.
* [gvm](https://github.com/moovweb/gvm) - similar to nvm
* [goenv](https://github.com/syndbg/goenv) - similar to pyenv

And there is https://golang.org/doc/install#extra_versions. It allows having multiple versions of Go with different names
```bash
$ go get golang.org/dl/go1.14
$ go1.14 download
Downloaded   0.0% (    15120 / 123550266 bytes) ...
Downloaded   0.1% (    64260 / 123550266 bytes) ...
Downloaded   4.1% (  5095424 / 123550266 bytes) ...
....
<snip snip>
....
Downloaded  96.0% (118654867 / 123550266 bytes) ...
Downloaded 100.0% (123550266 / 123550266 bytes)
Unpacking /home/santosh/sdk/go1.14/go1.14.linux-amd64.tar.gz ...
Success. You may now run 'go1.14'
$ go1.14 version
go version go1.14 linux/amd64
```

Probably this is the easiest way to install a new version as the command is built into the go tool. We can just set an alias to `go` for the current version we want to use.

## go download implementation
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

This process can be used for forming the download link for a given Go version.

I started with a feeling that something needs to be fixed but it looks like the solutions are already there.

So, what do I need for my use case?
* Able to download latest go version
* Able to switch to the new go version
* Have `go` as an alias to the current version.

The last point could have a downside for someone who frequently switched between different go versions. Using something like `go1.14` instead of `go` makes it clear which version is being used.

Normally I follow the steps provided at https://golang.org/doc/install#install. This keeps the installation at `/usr/local`. If I want to reinstall Go, I have to do as root. It would be nice If I just have the installation under my home directory.

## User interface
```bash
$ # install a go version
$ lei install 1.15
$ # list available versions
$ lei list
$ # set alias go to given version
$ lei use 1.15
$ # update to latest Go version
$ lei update
```

Now I'm feeling like I have got the NIH(Not Invented Here) syndrome <b style="writing-mode:vertical-rl">:{</b>

Anyway, this is a chance to write more Go code. So I'll go ahead and implement it.

## Implementation
### install
`lei install 1.15` should install Go 1.15 but doesn't switch the current installation to version 1.15. 

<u>Approach 1:</u><br>
A wrapper around shell commnands - wget, tar etc. This will be a straighforward implementation. But it relies on having the commands installed already.

<u>Approach 2:</u><br>
Use the code available in golang.org/dl/internal package. This should allow for a platform independant implemenation. On the other hand ideally one shouldn't rely on the internal package. It's not expected to be used by other packages hence internal.

<u>Approach 3:</u><br>
Find libraries implementing functions for downloading, extracting tarballs. This address the shortcomings of the above two approaches. Either we can extract the code from golang.org./dl/internal package or find other packages providing similar features or write my own one.

Place of installation?<br>
Since it is intended to use without the need for root permissions. It can be placed in the $HOME directory.

`$HOME/.lei/bin` -  will contain `go`, which will be a symlink to the wanted Go version. Make an entry in `.profile` to include in `$PATH`<br>
`$HOME/.lei/versions/` - subdirectories will be like `go.1.14`, `go.1.15` etc where each will contain an installation of the version.

Where will the tarball be downloaded?<br>
For simplicity we can let it download in the current directory where `lei` is running.

### list
`lei list` should list of available Go versions. For more info it could add a status in the output indicating whether that version is already installed or not.

https://pkg.go.dev/golang.org/x/website/internal/dl?tab=doc contains a link which provides a JSON containing metadata bout different Go version and download file names.

https://golang.org/dl/?mode=json to get a fix number of last Go releases.<br>
https://golang.org/dl/?mode=json&include=all to get for Go releases starting 1.14.

### use
`lei use 1.15` should update the `go` symlink to the Go version 1.15. If version 1.15 is not installed, it should be installed first.

### update
`lei update` should install the latest Go version and set to use it. It's like a combination of the `install` and `use` command.

## Show me the code!?

It should live at - [https://github.com/heisantosh/lei](https://github.com/heisantosh/lei)
