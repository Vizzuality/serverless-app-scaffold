# Global Rangelands Cloud Functions

[Documentation of the library](https://www.npmjs.com/package/@google-cloud/functions-framework) to simulate a cloud function in your local machine.
In order to deploy the cloud function you need to create a service account and a bucket in Google Cloud Storage.

Also automatic deployment of the cloud function is available at push in staging/production

## Some_Function

This is a simple placeholder "Hello World" CF, based on TS and Express (used for convenience in case you need more complex path handling, such as receiving path parameters, or sophisticated routing), but it could be written as a single function export in case you need something extremely light weight, with the usual `req` and `res` objects; refer to GCP's documentation. 

For local development:
1. Go to the folder `some_function`
2. For development run `npm install && npm run watch`.
3. Open the browser and go to `http://localhost:8080/`


### Deploying the function

```bash
gcloud functions deploy <function_name> --region=<region> --source ./cloud-functions/some_function
```

Example request 
``` bash
curl --request GET 'https://us-central1-mangrove-atlas-246414.cloudfunctions.net/fetch-alerts?location_id=MOZ&start_date=2019-01-01&end_date=2022-01-01'
```
