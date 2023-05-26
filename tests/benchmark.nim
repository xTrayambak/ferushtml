import ferushtml, times, os, strutils, math

if paramCount() < 1:
  echo "Give arguments as to how many times the test should be run!"
  quit 1

if paramCount() < 2:
  echo "Give what to test? (html parse=hp, html parse+dump=hdump)"
  quit 1

if paramCount() < 3:
  echo "Give test file path!"
  quit 1

let x = paramStr(1)
  .parseInt()

let shouldDump = paramStr(2) == "hdump"

let p = paramStr(3)

var 
  pSpeeds: seq[float32] = @[]
  dSpeeds: seq[float32] = @[]

var parser = newHTMLParser()

for _ in 0..x:
  var dTimeTaken: float32
  let pTimeStart = cpuTime()
  var data = parser.parse(readFile(p))
  let pTimeTaken = cpuTime() - pTimeStart

  if shouldDump:
    let dTimeStart = cpuTime()
    let dumped = data.dump()
    dTimeTaken = cpuTime() - dTimeStart

  pSpeeds.add(pTimeTaken)
  dSpeeds.add(dTimeTaken)

let pSpeedAvg = (sum(pSpeeds) / dSpeeds.len.float) * 1000
let dSpeedAvg = (sum(dSpeeds) / dSpeeds.len.float) * 1000

echo "TEST RESULTS\n"
echo "Rounds used (higher=more accurate): " & $x
for idx, s in pSpeeds:
  echo "Parse Round #" & $idx & ": " & $(s*1000) & " ms"

echo "Avg. parse time :   " & $pSpeedAvg & " ms"
echo "Total parse time:  " & $sum(pSpeeds) & " ms"

if shouldDump:
  for idx, d in dSpeeds:
    echo "Dump Round #" & $idx & ": " & $(d*1000) & " ms"

  echo "Avg. dump time :  " & $dSpeedAvg & " ms"
  echo "Total dump time: " & $sum(dSpeeds) & " ms"
