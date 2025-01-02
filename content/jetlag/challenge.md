+++  
title = 'Challenges'  
date = 2024-12-30T14:51:02-05:00  
draft = false
+++

## Random Page Selector

Click the button to visit a random page:

<button id="random-button">Go to Random Page</button>

<script>
  document.getElementById('random-button').onclick = function() {
    // Generate a random number between 1 and 100
    const randomNumber = Math.floor(Math.random() * 100) + 1;

    // Construct the URL for the random page
    const randomPageUrl = `/jetlag/random/${randomNumber}/`;

    // Redirect to the random page
    window.location.href = randomPageUrl;
  };
</script>
