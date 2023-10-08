curl -X POST 'https://api.resend.com/emails' \
  -H 'Authorization: Bearer re_7HyX7M4e_7Yp6oJdWxiiHuoDVBhCxop75' \
  -H 'Content-Type: application/json' \
  -d $'{
    "from": "onboarding@resend.dev",
    "to": "devancherneski@gmail.com",
    "subject": "Hello World",
    "html": "<p>Congrats on sending your <strong>first email</strong>!</p>"
  }'
