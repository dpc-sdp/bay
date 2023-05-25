# Container Image - bay-ripple-static

Provides a ripple static site generator image optimised for the Bay container platform.

## Usage

This image is designed to replace the `singledigital/bay-node` image in a frontend that is utilising static builds.

It is designed to work with the following `lagoon.type` values:

- `node`
- `node-persistent`

It should be used with a `FROM` statement in your projects docker file. It expects your application code to be available in `/app`, for example:

```
FROM singledigital/bay-ripple_static:5.x

COPY . /app
WORKDIR /app

RUN . /home/.bashrc \
  && npm i \
  && npm run build

WORKDIR /builder
```

The image exposes a simple queue service that provides an API endpoint to queue static website builds. There is a companion Drupal module that can assist in making these requests automatically when content changes. To create a queue entry for the build:

```
curl --request POST \
  --url http://ripple-static/api/deploy \
  --header 'Content-Type: application/json' \
  --data '{
	"pages": [],
	"force": false,
	"skipUnpublish": false,
	"attachments": true
}'
```

## Environment Variables

The queue service requires the following environment variables to be defined in your deployment:

| Name             | Default Value | Description                                                         |
| ---------------- | ------------- | ------------------------------------------------------------------- |
| `QUANT_CUSTOMER` | nil           | The customer name for QuantCDN that you want to push the results to |
| `QUANT_PROJECT`  | nil           | The project name in QuantCDN for this static deployment             |
| `QUANT_TOKEN`    | nil           | The API token that has write access to QuantCDN                     |
| `BUILD_DIR`      | `"dist""`     | The location of the static site build relative to `WORKDIR /app`    |

## Ports

- 3000 - Queue endpoint

## Query parameters

| Name            | Default Value | Description                                                                   |
| --------------- | ------------- | ----------------------------------------------------------------------------- |
| `pages`         | `[]`          | A list of pages that are passed to  the `npm run generate` stage of the build |
| `force`         | `false`       | Force push static assets to QuantCDN                                          |
| `skipUnpublish` | `false`       | Skip unpublish items that are no longer found in the static output            |
| `attachments`   | `true`        | Follow attachment URLs (images, media) and include those in the push          |

## Queue runner

The queue runn executes stages in the context of `/app`. Copy your static site generator into the `/app` location during the site build. The queue worker allows the application to determine build and testing phases via npm tasks.

| Task Name     | Description                                                                                                                        |
| ------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| `generate`    | Genereate the static assets, output is expected in `$BUILD_DIR` (eg. `/app/dist`)                                                  |
| `test:static` | Perform validations to ensure the static site has been generated correctly, if this command fails the deployment will be cancelled |

It is expected that you defined these tasks in your applications `package.json` file so that the queue workers can execute them correctly.