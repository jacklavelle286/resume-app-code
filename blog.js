document.addEventListener('DOMContentLoaded', function() {
 fetchBlogPosts();

 // Function to fetch blog posts
 function fetchBlogPosts() {
     const apiEndpoint = 'https://nf3mczr6b2rsnfhpgaikpejlry0bnlkg.lambda-url.us-east-1.on.aws/'; // Replace with your actual API endpoint
     fetch(apiEndpoint)
         .then(response => {
             if (!response.ok) {
                 throw new Error(`HTTP error! Status: ${response.status}`);
             }
             return response.text();
         })
         .then(htmlContent => {
             // Inject the HTML content into the posts container
             document.getElementById('posts-container').innerHTML = htmlContent;
         })
         .catch(error => {
             console.error('Error fetching blog posts:', error);
             document.getElementById('posts-container').innerHTML = '<p>Failed to load blog posts. Please try again later.</p>';
         });
 }
});

