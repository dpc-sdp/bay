<p align="center"><a href="https://www.drupal.org/project/tide" target="_blank"><img src="docs/images/SDP_Bay_product_logo_JPG.JPG" alt="SDP logo" height="150"></a></p>
<p align="center"><i>Bay is the hosting and infrastructure layer for Single Digital Presence, delivered using amazee.io Lagoon.</i></p>

<!-- TABLE OF CONTENTS -->
## Table of Contents
* [About](#About)
  * [amazee.io Lagoon](#amazeeio-lagoon)
* [Use](#use)
* [Contribute](#contribute)
* [Support](#support)
* [License](#license)
* [Attribution](#Attribution)

## About
Bay is a fully managed platform and hosting environment that provides an open Platform as a Service model managed by SDP. It:
 - is an open-source hosting platform based on Lagoon.
 - allows agencies to build, test and deliver websites via the cloud.
 - is a Kubernetes-based (OpenShift) Docker container hosting platform with auto-scaling, auto-recovery and high-availability at core.
 - is based on open-source project Lagoon.

### amazee.io Lagoon
Lagoon solves what developers are dreaming about: A system that allows developers to locally develop their code and their services with Docker and run the exact same system in production. The same Docker images, the same service configurations and the same code.

## Use
Learn more from https://lagoon.readthedocs.io/en/latest/

## Bay Features

### Lock-down Ingress with Pre-Shared Key

Using the nginx image, you can lock down access to your application with using a pre-shared key added at your CDN. 

Set these environment variables in your nginx deployment:

- `BAY_INGRESS_HEADER` defines the header which has the pre-shared key.
- `BAY_INGRESS_PSK` is the token / PSK value.
- `BAY_INGRESS_ENABLED` is a toggle for this feature, must be set to `"true"`.

In your CDN configuration, set the header defined in `BAY_INGRESS_HEADER` with the token defined in `BAY_INGRESS_PSK`.

- [Cloudfront](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/add-origin-custom-headers.html)

Once deployed, if the header is missing in the request nginx will return a `405 Not Allowed` HTTP response.

## Contribute
[Open an issue](https://github.com/dpc-sdp/bay) on GitHub or submit a pull request with suggested changes.

## Image versioning and release management
Bay images use the following versioning model, tied to git branches of the same name.

A major version is identified with a numeral and the minor version is abstracted to `x`. This provides flexibility for 
future versioning requirements.

In practice this looks like `1.x`, `2.x` etc.

At any one time the two most recent tags are supported. These are identified based on numerical order.

The lower value tag references a 'production safe' image.

The higher value tag includes major updates to the image in testing.

### Pull request base branches
Pull requests that introduce potential breaking changes, like a major version bump of PHP, should use the latest version
branch as their base.

Incremental and time critical changes can use the current production safe branch as the base.

Example scenario:
Supported tags: `1.x` and `2.x`
Breaking change base branch: `2.x`
Incremental or security update base branch `1.x`

### Fixed branch tags
Fixed branches, those that are fixed for the QA, UAT, release pipeline have corresponding images tagged to ensure a 
point of reference during the development cycle.

The goal of this is to provide a clear point of reference for testing changes. 

These images are generated from the corresponding branch in the Bay repository.

## Support
[Digital Engagement, Department of Premier and Cabinet, Victoria, Australia](https://github.com/dpc-sdp)
is a maintainer of this package.

## License
This project is licensed under [GPL2](https://github.com/dpc-sdp/bay/blob/master/LICENSE)

## Attribution
Single Digital Presence offers government agencies an open and flexible toolkit to build websites quickly and cost-effectively.
<p align="center"><a href="https://www.vic.gov.au/what-single-digital-presence-offers" target="_blank"><img src="docs/images/SDP_Logo_VicGov_RGB.jpg" alt="SDP logo" height="150"></a></p>

The Department of Premier and Cabinet partnered with Salsa Digital to deliver Single Digital Presence. As long-term supporters of open government approaches, they were integral to the establishment of SDP as an open source platform.
<p align="center"><a href="https://salsadigital.com.au/" target="_blank"><img src="docs/images/Salsa.png" alt="Salsa logo" height="150"></a></p>
