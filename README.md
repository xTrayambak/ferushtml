# ferushtml/2html5you -- a standards compliant, browser-grade, flexible, fast and secure HTML parser for Ferus
There's not much to be seen here.
In the future there will be a consume-based parser, but for now only a FSM parser is available.
ferushtml is designed to be able to abstract Ferus' codebase, whilst still maintaining 1:1 compatibility with src/parsers/html in Ferus

# How fast is it?
These tests are derived from an Intel i3 3217u @ 1.80 Ghz and 16 GB RAM (not really necessary)
You can try these for yourselves at [tests/benchmark.nim](https://github.com/xTrayambak/ferushtml/blob/main/tests/benchmark.nim)
```
$ nim c tests/benchmark.nim
$ cd tests
$ ./benchmark 8 hp test.html # HTML parsing
<.....>
$ ./benchmark 8 hdump test.html # HTML parsing + dump
<.....>
```
Results (2 rounds):
| Flags                  | Total Parse Time             | Total Dump Time      |
| ---------------------- | ---------------------------- | -------------------- |
| -d:release             | 0.1415580014387766 ms        | 6.068949222564697 ms |
| -d:debug               | 0.2515160044034322 ms        | 17.32665252685547 ms |
| -d:release + -d:danger | 0.09334433078765869 ms       | 1.784406900405884 ms |
| -d:debug + -d:danger   | 0.4544500112533569 ms        | 3.415278196334839 ms |

