# Turbo-charge your PHP applications with Roadrunner

This is the demo application accompanying the blog post at [https://davegebler.com/post/php/turbo-charge-your-php-applications-with-roadrunner](https://davegebler.com/post/php/turbo-charge-your-php-applications-with-roadrunner)

## Run the demo

Clone this repo, then from the project directory, run:

```bash
cd symfony/var/certs
chmod +x ./makecerts.sh
./makecerts.sh
cd ../../..
docker compose build roadrunner
docker compose up -d
```

This will spin up the test script on http://localhost:8080

And the Symfony application on http://localhost:8081 and https://localhost:8082

You will need to add the generated `symfony/var/certs/client.p12` file to your browser's trusted certificates for use 
as a client certificate.