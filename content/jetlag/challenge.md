---
title: Random button
draft: false
---

## press for random page

<html>
<body style="font-size: 20px; text-align: center;">
		<button id="randomChallengeButton" class="custom-button">Random Challenge (click to earn coins!)</button>
  <script>
    document.getElementById("randomChallengeButton").addEventListener("click", function() {
      const randomNumber = Math.floor(Math.random() * 100) + 1;
      const randomChallengeFile = "challenges/" + randomNumber + ".html";
      window.location.href = randomChallengeFile;
    });
  </script>
</body>
</html>