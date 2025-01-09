document.addEventListener('DOMContentLoaded', () => {
    document.body.innerHTML = document.body.innerHTML.replace(/==([^=]+)==/g, '<span class="highlight">$1</span>');
});
