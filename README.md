<p align="center"><a href="https://www.drupal.org/project/tide" target="_blank"><img src="docs/images/SDP_Bay_product_logo_JPG.JPG" alt="SDP logo" height="150"></a></p>
<p align="center"><i>Bay is the hosting and infrastructure layer for Single Digital Presence, delivered using amazee.io Lagoon.</i></p>

<!-- TABLE OF CONTENTS -->
# Table of Contents
* [About](#About)
  * [amazee.io Lagoon](#amazeeio-lagoon)
* [Use](#use)
* [Contribute](#contribute)
* [Support](#support)
* [License](#license)
* [Attribution](#Attribution)

# About
Bay is a fully managed platform and hosting environment that provides an open Platform as a Service model managed by SDP. It:
 - is an open-source hosting platform based on Lagoon.
 - allows agencies to build, test and deliver websites via the cloud.
 - is a Kubernetes-based (OpenShift) Docker container hosting platform with auto-scaling, auto-recovery and high-availability at core.
 - is based on open-source project Lagoon.

## amazee.io Lagoon
Lagoon solves what developers are dreaming about: A system that allows developers to locally develop their code and their services with Docker and run the exact same system in production. The same Docker images, the same service configurations and the same code.

# Use
Learn more from https://lagoon.readthedocs.io/en/latest/

# Bay Features

## Lock-down Ingress with Pre-Shared Key

Using the nginx image, you can lock down access to your application with using a pre-shared key added at your CDN. 

Set these environment variables in your nginx deployment:

- `BAY_INGRESS_HEADER` defines the header which has the pre-shared key.
- `BAY_INGRESS_PSK` is the token / PSK value.
- `BAY_INGRESS_ENABLED` is a toggle for this feature, must be set to `"true"`.

In your CDN configuration, set the header defined in `BAY_INGRESS_HEADER` with the token defined in `BAY_INGRESS_PSK`.

- [Cloudfront](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/add-origin-custom-headers.html)

Once deployed, if the header is missing in the request nginx will return a `405 Not Allowed` HTTP response.

# Contribute
[Open an issue](https://github.com/dpc-sdp/bay) on GitHub or submit a pull request with suggested changes.

# Support
[Digital Engagement, Department of Premier and Cabinet, Victoria, Australia](https://github.com/dpc-sdp)
is a maintainer of this package.

# License
This project is licensed under [GPL2](https://github.com/dpc-sdp/bay/blob/master/LICENSE)

# Attribution
Single Digital Presence offers government agencies an open and flexible toolkit to build websites quickly and cost-effectively.
<p align="center"><a href="https://www.vic.gov.au/what-single-digital-presence-offers" target="_blank"><img src="docs/images/SDP_Logo_VicGov_RGB.jpg" alt="SDP logo" height="150"></a></p>

The Department of Premier and Cabinet partnered with Salsa Digital to deliver Single Digital Presence. As long-term supporters of open government approaches, they were integral to the establishment of SDP as an open source platform.
<p align="center"><a href="https://salsadigital.com.au/" target="_blank"><img src="docs/images/Salsa.png" alt="Salsa logo" height="150"></a></p>
