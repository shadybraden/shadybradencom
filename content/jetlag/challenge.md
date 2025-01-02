+++  
title = 'Challenges'  
date = 2024-12-30T14:51:02-05:00  
draft = false
+++

# Random Page Selector

Click the button to visit a random page: <button id="random-button">Go to Random Page</button> <style> #random-button { padding: 10px 20px; background-color: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; } #random-button:hover { background-color: #0056b3; } </style> <script> document.getElementById('random-button').onclick = function() { // Generate a random number between 1 and 100 const randomNumber = Math.floor(Math.random() * 100) + 1; // Construct the URL for the random page const randomPageUrl = `/website/random/${randomNumber}/`; // Redirect to the random page window.location.href = randomPageUrl; }; </script>