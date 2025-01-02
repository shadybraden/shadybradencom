+++  
title = 'Challenges'  
date = 2024-12-30T14:51:02-05:00  
draft = false
+++

## Challenges

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Random Challenge</title>
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
</head>
<body style="font-size: 20px; text-align: center;">
    <button id="randomChallengeButton" class="custom-button">Random Challenge (click to earn coins!)</button><br>

    <script>
        document.getElementById("randomChallengeButton").addEventListener("click", function() {
            // Generate a random number between 1 and 100
            const randomNumber = Math.floor(Math.random() * 95) + 1; // 95 is the maximum value, adjust if needed

            // Build the file name based on the random number
            const randomChallengeFile = "challenges/" + randomNumber + ".html";

            // Open the random challenge file
            window.location.href = randomChallengeFile;
        });
    </script>
</body>
</html>
