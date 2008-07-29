= CIAT (Compiler and Interpreter Acceptance Tester)

== DESCRIPTION:

CIAT (pronounced "dog") provides a system for writing high-level acceptance tests for compilers and
interpreters. Each acceptance test is entered into a single file, including the test's description, source
code, expected target code, and even expected result when executed.

== FEATURES/PROBLEMS:

* Description, source code, expected target code, and expected output stored in one file.
* Tests are executed from a single directory.
* Project is _very_ immature, so many things are hard coded (have to compile, have to execute, have to
  compare with +diff+), and other things are _very_ fluid (like the file format).

== SYNOPSIS:

A sample +Rakefile+:

  require 'ciat'
  require 'ciat/compiler_in_java'
  require 'ciat/executors/parrot'

  task :default do
    CIAT::Base.run_tests(make_compiler, CIAT::Executors::Parrot.new)
  end

  def make_compiler
    CIAT::CompilerInJava.new(classpath, 'org.norecess.hobbes.drivers.PIRCompiler')
  end

  def classpath
    Dir.glob('../lib/*.jar').join(':') + ":../bin"
  end

A sample input file (<code>simpleinteger5.txt</code>):

  Compiles a simple integer.
  ====
  5
  ====
  .sub main
    print 5
    print "\n"
  .end
  ====
  5

Test files must be named with a <code>.txt</code> (for now).  Contents must be ordered: description, source input, expected target code, expected execution output (again, for now).

== REQUIREMENTS:

* Pronounce "CIAT" as "dog".
* Must have +diff+ executable.
* You have to provide your own target-code executors (e.g., +parrot+ for the Parrot Virtual Machine, +spim+
  for MIPS emulation, etc.)

== INSTALL:

* Install +diff+.
* sudo gem install jdfrens-ciat

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
