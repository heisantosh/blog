---
title: "Contents of a Hello world Go program"
date: 2019-09-10T09:49:15+05:30
draft: true
---

A hello world in program in Go is 7 lines long. Any text editor which supports UTF-8 can be used to write a Go program. Then we can compile and run it. Here we explore the contents of a "Hello world." from its creation to its execution.

Below is a Go program that should print "Hello world." when it's compiled and executed. As described in the Go language spec https://golang.org/ref/spec#Source_code_representation - "Source code is Unicode text encoded in UTF-8."
For consistency it's always recommended to run <code>go fmt</code> or <code>gofmt</code> on Go file https://blog.golang.org/go-fmt-your-code. 

{{<highlight bash>}}
$ cat > hello.go
package main

import "fmt" 

func main() {
	fmt.Println("Hello world.")
}
{{</highlight>}}

Now let's build the program. I'm performing this task on system with below configuration:

{{<highlight bash>}}
$ uname -srvmpio
Linux 4.15.0-60-generic #67-Ubuntu SMP Thu Aug 22 16:55:30 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
{{</highlight>}}

{{<highlight bash>}}
$ go build
$ ls -l
total 1980
drwxr-xr-x  2 santosh santosh    4096 Sep 10 10:25 ./
drwxr-xr-x 19 santosh santosh    4096 Sep 10 10:19 ../
-rw-r--r--  1 santosh santosh      31 Sep 10 10:24 go.mod
-rwxr-xr-x  1 santosh santosh 2008649 Sep 10 10:25 hello*
-rw-r--r--  1 santosh santosh      73 Sep 10 10:21 hello.go
$ file hello
hello: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically linked, not stripped
{{</highlight>}}

Interesting, the difference is in size between the compile executable file <code>hello</code> and source code <code>hello.go</code> is around 2 mega bytes. Let's try looking at the contents of the files to understand it.

We can easily see the contents of the file <code>hello.go</code> file using <code>cat</code> command. But if we try to do the same on <code>hello</code>, the terminal screen is filled with mostly intangible text. Let's use head to see what the first lien looks like.

{{<highlight bash>}}
$ head -1 hello
ELF>pKE@�@8@@@@@@����@�@dd@@���H�H��
                                                        ��
                                                          ��T�T`A!Q�td�dW��M���H�
�� '�T�  �T ��� aUaPp `�U`�P� ��W��X' ��W��W�&`�?!Y?
Av!��Y���B��Y���SJ�YJ�*�t�Yt����W�\W��Q�5^5!95�@�d��������
{{</highlight>}}

We can see ELF there at the very beginning, which we can relate to as it is an ELF 64-bit LSB executable. But the rest looks like a collection of random letters, boxes and lots of question marks.

Ok, what about the end? Let's check -

{{<highlight bash>}}
$ tail -1 hello
 �H�go.goruntime.textruntime.etext$f64.3ff0000000000000$f64.3eb0000000000000$f64.403a000000000000$f64.bfe62e42fefa39ef$f64
.3fec000000000000$f64.3ffe000000000000$f64.43e0000000000000$f64.3fd0000000000000$f64.3fe0000000000000$f64
.bfd3333333333333$f64.3fd3333333333333$f64.4059000000000000$f64.3ff199999999999a$f64.3ff3333333333333$f64
.3fee666666666666$f64.40f0000000000000$f64.4024000000000000$f64.8000000000000000$f64.4014000000000000$f64
.fffffffffffffffe$f32.ffffffferuntime.reflectcall.args_stackmapruntime.publicationBarrier.args_stackmapruntime
.asmcgocall.args_stackmapruntime.call32.args_stackmapruntime.call64.args_stackmapruntime.call128.args_stackmapruntime
.call256.args_stackmapruntime.call512.args_stackmapruntime.call1024.args_stackmapruntime.call2048.args_stackmapruntime
.call4096.args_stackmapruntime.call8192.args_stackmapruntime.call16384.args_stackmapruntime.call32768.args_stackmapruntime
.call65536.args_stackmapruntime.call131072.args_stackmapruntime.call262144.args_stackmapruntime.call
{{</highlight>}}

The output was tool large, so above is the start of the output. We can see a couple of things here - <code>goruntime</code>, <code>textruntime</code> and lots of <code>args_stackmapruntime</code>.

And below is the end of the output -

{{<highlight bash>}}
os.NewFileos.newFileos.(*file).closeos.Readlinkos.init.0os.glob..func1os.inittype..hash.os.filetype..eq.os.filetype
..hash.os.PathErrortype..eq.os.PathErrorfmt.(*fmt).writePaddingfmt.(*fmt).padfmt.(*fmt).padStringfmt.(*fmt).
fmtBooleanfmt.(*fmt).fmtUnicodefmt.(*fmt).fmtIntegerfmt.(*fmt).truncateStringfmt.(*fmt).truncatefmt.
(*fmt).fmtSfmt.(*fmt).fmtBsfmt.(*fmt).fmtSbxfmt.(*fmt).fmtQfmt.(*fmt).fmtCfmt.(*fmt).fmtQcfmt.(*fmt).fmtFloatfmt.
(*buffer).writeRunefmt.newPrinterfmt.(*pp).freefmt.(*pp).Widthfmt.(*pp).Precisionfmt.(*pp).Flagfmt.
(*pp).Writefmt.Fprintlnfmt.getFieldfmt.(*pp).unknownTypefmt.(*pp).badVerbfmt.(*pp).fmtBoolfmt.(*pp).fmt0x64fmt.
(*pp).fmtIntegerfmt.(*pp).fmtFloatfmt.(*pp).fmtComplexfmt.(*pp).fmtStringfmt.(*pp).fmtBytesfmt.(*pp).fmtPointerfmt.
(*pp).catchPanicfmt.(*pp).handleMethodsfmt.(*pp).printArgfmt.(*pp).printValuefmt.
(*pp).doPrintlnfmt.glob..func1fmt.inittype..hash.fmt.fmttype..eq.fmt.fmtmain.main
{{</highlight>}}

Here we see <code>fmt.fmtmain.main</code> right at the end, which is probably our main function which prints "Hello world.". It looks there are methods from the <code>fmt</code> and <code>os</code> packages. But we never included the <code>os</code> package. On further examination of the output I can see other package names as well <code>strconv</code>, <code>runtime</code>, <code>sync</code> etc.

Using <code>go list</code> we can the list of dependencies. Below is a listing of all dependencies of the <code>hello.io/hello</code> package.

{{<highlight bash>}}
$ cat go.mod
module hello.io/hello

go 1.13
$ go list -f '{{ join .Deps "\n" }}' hello.io/hello
errors
fmt
internal/bytealg
internal/cpu
internal/fmtsort
internal/oserror
internal/poll
internal/race
internal/reflectlite
internal/syscall/unix
internal/testlog
io
math
math/bits
os
reflect
runtime
runtime/internal/atomic
runtime/internal/math
runtime/internal/sys
sort
strconv
sync
sync/atomic
syscall
time
unicode
unicode/utf8
unsafe
$ go list -f '{{ join .Deps "\n" }}' hello.io/hello | wc -l
29
{{</highlight>}}

That's 29 packages there. Honestly, I didn't expect that many for this hello world program.

So, it seems like the executable also includes all the dependent packages and we know that Go generates a single static executable binary. In the FAQ page of Go website there is a section https://golang.org/doc/faq#Why_is_my_trivial_program_such_a_large_binary. It says:

<blockquote class="quote">
All Go binaries therefore include the Go runtime, along with the run-time type information necessary to support dynamic type checks, reflection, and even panic-time stack traces.
</blockquote>

This explains what was seen in the contents of <code>hello</code>.
The FAQ also mentions:

<blockquote class="quote">
A Go program compiled with gc can be linked with the -ldflags=-w flag to disable DWARF generation, removing debugging information from the binary but with no other loss of functionality. This can reduce the binary size substantially.
</blockquote>

Rebuilding with this flag we can see that size of the binary has reduce by about half a mega byte.

{{<highlight bash>}}
$ go build -ldflags=-w 
santosh@ideapad:~/Devel/hello$ ll
total 1548
drwxr-xr-x  2 santosh santosh    4096 Sep 11 09:58 ./
drwxr-xr-x 19 santosh santosh    4096 Sep 10 10:19 ../
-rw-r--r--  1 santosh santosh      31 Sep 10 10:24 go.mod
-rwxr-xr-x  1 santosh santosh 1566281 Sep 11 09:58 hello*
-rw-r--r--  1 santosh santosh      73 Sep 10 10:21 hello.go
$ ./hello 
Hello world.
{{</highlight>}}

To understand the contents and the structure of the binary <code>hello</code> it will depend on the type of OS and the hardware it was built for. In this case I'm looking at a binary for 64 bit Ubuntu OS 18.04.3 running on x64 hardware. The binary is in ELF format as we found out earlier.

{{<highlight bash>}}
$ file hello
hello: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically linked, not stripped
{{</highlight>}}

There are tools such as <code>readelf</code> and <code>objdump</code> to see the details of an ELF file. I'll have another post to explore using these tools.

🌺 🌺 🌺