// Function to invoke the Lambda function URL and update the view count
function updateViewCount() {
    fetch('https://z2kltlv5pfqohellydxepx7yxq0hpoad.lambda-url.us-east-1.on.aws/')
    .then(response => response.json())
    .then(data => {
        if (data && data.ViewCount !== undefined) {
            document.getElementById('view-count').innerText = `Views: ${data.ViewCount}`;
        } else {
            console.error('Invalid response data:', data);
        }
    })
    .catch(error => {
        console.error('Error fetching view count:', error);
    });
}

// Function to handle contact form submission
function submitContactForm(event) {
    event.preventDefault();

    // Capture form data
    var name = document.getElementById('name').value;
    var email = document.getElementById('email').value;
    var message = document.getElementById('message').value;

    // Construct the request payload
    var formData = {
        name: name,
        email: email,
        message: message
    };

    // Send the data to the Lambda function URL
    fetch('https://klh7p6awz3hritn2yiuuwkybxm0xwnbh.lambda-url.us-east-1.on.aws/', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(formData)
    })
    .then(response => response.json())
    .then(data => {
        alert('Thank you for your message!');
        // Optionally, clear the form or handle the response further
    })
    .catch(error => {
        console.error('Error submitting contact form:', error);
    });
}

// Event listeners
document.addEventListener('DOMContentLoaded', function() {
    updateViewCount();

    // Attach the event listener to the contact form
    var contactForm = document.getElementById('contact-form');
    if (contactForm) {
        contactForm.addEventListener('submit', submitContactForm);
    }
});
