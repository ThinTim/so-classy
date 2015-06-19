# SoClassy

SoClassy is a web application designed to be deployed within an organisation to facilitate knowledge transfer and shared learning.

The application consists of a basic Rails 4 app, with a few ReactJS components on the front end for improved UX.

## Configuration

By default, the application is set up to be deployed via Heroku with the following addons:

- postgres (database)
- newrelic (performance monitoring)
- papertrail (logging)
- sendgrid (emails)

The following custom environment variables should be set in order for the application to function correctly:

- HOST_URL (required) (set to `yourappurl.com`, otherwise urls cannot be generated in emails sent by the application)
- USER_EMAIL_DOMAIN (required) (set to `example.com` to limit signups to users who have an '@example.com' email address. Use `.*` to allow any domain.) 
- GOOGLE_ANALYTICS_ID (optional)
