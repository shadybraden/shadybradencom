---
draft: false
tags:
- jetlag
title: Map
weight: 3
---

## [Click Here](https://taibeled.github.io/JetLagHideAndSeek/?hz=eyJ0eXBlIjoiRmVhdHVyZUNvbGxlY3Rpb24iLCJmZWF0dXJlcyI6W3sidHlwZSI6IkZlYXR1cmUiLCJwcm9wZXJ0aWVzIjp7fSwiZ2VvbWV0cnkiOnsidHlwZSI6IlBvbHlnb24iLCJjb29yZGluYXRlcyI6W1tbLTcwLjk4NDAzOSw0Mi4zOTUwNjZdLFstNzAuOTg3NDczLDQyLjQyMzQ1N10sWy03MS4wNDY4NjcsNDIuMzg2NDQ0XSxbLTcxLjA2NzU1Myw0Mi40NDQ4NjhdLFstNzEuMTQ3NjMzLDQyLjM5NzIyMV0sWy03MS4xMzIxODMsNDIuMzU1NDk5XSxbLTcxLjE3NzY3Myw0Mi4zNDEwMzZdLFstNzEuMTY0Nzk5LDQyLjMzMzU1XSxbLTcxLjEzMzM4NSw0Mi4zNDM4MjhdLFstNzEuMTEyNDQyLDQyLjM0ODUyMl0sWy03MS4wODk2MTEsNDIuMzQ0ODQzXSxbLTcxLjExMTU4NCw0Mi4zMzY0NjhdLFstNzEuMTIzOTQzLDQyLjMxMTk3M10sWy03MS4xMDcxMjEsNDIuMzAzNzIyXSxbLTcxLjA2NTA2Myw0Mi4zMzY5NzZdLFstNzEuMDU5OTE0LDQyLjMyMDk4Nl0sWy03MS4wNzI2MTcsNDIuMjg3MjE1XSxbLTcxLjA4OTAxLDQyLjI3MTg0N10sWy03MS4wOTUzNjIsNDIuMjcwODk0XSxbLTcxLjEwMDQyNiw0Mi4yNjQzNTJdLFstNzAuOTk3MDg2LDQyLjE5NzQ5NV0sWy03MC45ODk1MzIsNDIuMzE2NjddLFstNzAuOTg0MDM5LDQyLjM5NTA2Nl1dXX19XSwicXVlc3Rpb25zIjpbXSwiZGlzYWJsZWRTdGF0aW9ucyI6W10sImhpZGluZ1JhZGl1cyI6MC4yNX0=)

![map](/mapoverlay.png)

---

Click the pin in the top right, then check the box to show hiding zones.
Make sure the radius is set to `0.25` and the types of stops are `Railway Stations` and `Railway Halts` 

The site caches your changes, so you should be able to close the site and reopen the app again (the above link will reset it to start) and resume where you were.
However, just so you don't loose progress, maybe have multiple people do the mapping.

---

Or:

- Copy below
- Go to [Map Splitting Site](https://taibeled.github.io/JetLagHideAndSeek)
- press `Options`>`Paste Hiding Zone` 

```json
{"type":"FeatureCollection","features":[{"type":"Feature","properties":{},"geometry":{"type":"Polygon","coordinates":[[[-70.984039,42.395066],[-70.987473,42.423457],[-71.046867,42.386444],[-71.067553,42.444868],[-71.147633,42.397221],[-71.132183,42.355499],[-71.177673,42.341036],[-71.164799,42.33355],[-71.133385,42.343828],[-71.112442,42.348522],[-71.089611,42.344843],[-71.111584,42.336468],[-71.123943,42.311973],[-71.107121,42.303722],[-71.065063,42.336976],[-71.059914,42.320986],[-71.072617,42.287215],[-71.08901,42.271847],[-71.095362,42.270894],[-71.100426,42.264352],[-70.997086,42.197495],[-70.989532,42.31667],[-70.984039,42.395066]]]}}],"questions":[],"disabledStations":[],"hidingRadius":0.25}
```