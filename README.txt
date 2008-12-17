= CIAT (Compiler and Interpreter Acceptance Tester)

== DESCRIPTION:

CIAT (pronounced "dog") provides a system for writing high-level acceptance
tests for compilers and interpreters. Each acceptance test is entered into a
single file, and that file identifies the elements of a test.


== SYNOPSIS:

Suppose you have a compiler written in Java that compiles a language named
Hobbes. Your compiler targets the Parrot Virtual Machine. So you want to
provide <em>source code</em> which is <em>compiled with a Java program</em>
and that result is <em>interpreted by Parrot</em>.

=== Input File

Input files should be named with a <code>.ciat</code> extension and saved in a
<code>ciat</code> folder.

A sample input file (<code>simpleinteger5.ciat</code>) for the scenario
described above might look like this:

  Compiles a simple integer.
  ==== source
  5
  ==== compilation
  .sub main
    print 5
    print "\n"
  .end
  ==== execution
  5

This file specifies <em>four</em> elements: description, <b>source</b>,
<b>compilation</b>, and <b>execution</b>. The description is always the first
element, always unlabeled, and used prominently in the HTML report. All of the
other elements are dependent on the processors that you use.

In this example, we're using a "Java compiler" (a compiler <em>written in</em>
Java) and a "Parrot executor". CIAT's "Java compiler" runs your compiler over
the <b>source</b>, and that output is compared to the <b>compilation</b>
element. Then the "Parrot executor" is executed with the <em>generated</em>
compilation, and that output is compared to the <b>execution</b> element.

If any processor fails, either due to an error while running or a failure
during checking the output, the remaining processors are not executed.

Some processors will use optional elements in a test file.  For example, the "Parrot executor" knows about command-line arguments:

	Compiles a simple integer and ignores the command-line arguments.
	==== source
	5
	==== compilation
	.sub main
	  print 5
	  print "\n"
	.end
	==== command line
	89 pqp
	==== execution
	5
	
When the "Parrot executor" is run on the compilation, it'll also pass in <code>89 pqp</code> as command-line arguments.

=== The Rakefile

This sample +Rakefile+ will pull everything together:

  require 'ciat'
  require 'ciat/compilers/java'
  require 'ciat/executors/parrot'

  task :ciat do
    CIAT::Suite.new(:processors => [compiler, executor]).run
  end

  def compiler
    classpath = Dir.glob('../lib/*.jar').join(':') + ":../bin"
    CIAT::Compilers::Java.new(classpath, 'org.norecess.hobbes.drivers.PIRCompiler')
  end

  def executor
    CIAT::Executors::Parrot.new
  end

This rakefile will find all of the <code>.ciat</code> files inside a +ciat+
directory, each one representing a test. Each test will be executed, and the
results are put into a folder named +temp+, including the HTML report
<code>report.html</code>. All of these settings can be tweaked; see the
documentation for CIAT::Suite for more information.


== REQUIREMENTS:

* Pronounce "CIAT" as "dog".
* Must have +diff+ executable.
* You have to provide your own target-code executors (e.g., +parrot+ for the
  Parrot Virtual Machine, +spim+ for MIPS emulation, etc.)


== INSTALL:

* Install +diff+.
* Install Ruby and Ruby Gems.
* <code>gem sources -a http://gems.github.com</code> (only needed once)
* <code>sudo gem install jdfrens-ciat</code>


== LICENSE:

(The MIT License)

Copyright (c) 2008 Jeremy D. Frens

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
