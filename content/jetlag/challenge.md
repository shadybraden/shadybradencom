+++  
title = 'Challenges'  
date = 2024-12-30T14:51:02-05:00  
draft = false
+++

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JARED DAY</title>
</head>
<body style="font-size: 20px; text-align: center;">
    <h1>Jet Lag(ish)</h1>
    <img src="jared.jpg" alt="jared" width="400" height="100"><br>
    <a href="intro.html">general info</a> | <a href="trains.html">TRAIN info</a> | <a href="https://www.mbta.com/">MBTA site</a><br>
    <a href="race.html">RACE</a> | <a href="tag.html">TAG</a> | <a href="poi.html">POI's</a> | <a href="hostage.html">Hostage</a><br><br>

        <style>
        .custom-button {
            width: 400px; /* This will make the button bigger */
            height: 75px;   /* This will make the button bigger */
            background-color: #00ff00; /* Custom background color */
            border: none;
            cursor: pointer;
            font-size: 20px; /* Increase the font size to make it larger */
        }
    </style>
    
    
      <button id="randomChallengeButton" class="custom-button">Random Challenge (click to earn coins!)</button><br>

  <script>
    document.getElementById("randomChallengeButton").addEventListener("click", function() {
      // Generate a random number between 1 and 100
      const randomNumber = Math.floor(Math.random() * 95) + 1; //edit the "2)" to set the max value based on the total number of challenges

      // Build the file name based on the random number
      const randomChallengeFile = "challenges/" + randomNumber + ".html";

      // Open the random challenge file
      window.location.href = randomChallengeFile;
    });
  </script>
    
  
    
    
    <table border="1" style="width: 80%; margin: 2% auto; text-align: center;">
    <tr>
        <th>THING</th>
        <th>COST</th>
    </tr>
    <tr>
        <td>commuter rail</td>
        <td>25/min</td>
    </tr>
    <tr>
        <td>subway</td>
        <td>10/min</td>
    </tr>
    <tr>
        <td>bus</td>
        <td>5/min</td>
    </tr>
    <tr>
        <td>bike</td>
        <td>1/min</td>
    </tr>
    <tr>
        <td>disable tracker for 5 mins</td>
        <td>1,000</td>
    </tr>
    <tr>
        <td>double effects of next card</td>
        <td>250</td>
    </tr>
</table>
| | | | | | | | | | | | | | | | | |<br>
\/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ <br>
<mark style="background: #ffff00;">GENERAL RULES BELOW:</mark><br><br><br>

based on estimated time, not actual (so based on the time listed at mbta.com) <br>

fail/veto = no transport for 15 mins<br><br>
(if you get on a train without enough coins to make it to your final destination, and take a challenge on the train, and fail, get off at the next stop)
<br><br>




select one person to use their calculator or notes to keep track of your teams coins

</body>
</html>