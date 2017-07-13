# Package List File Format

These files are a database of popular `.css`, `.ttf` and `.js` files ("packages") on content distribution networks (CDNs).

We differentiate between different versions of these packages. Here is an example for jQuery:

* `.latest` -- The latest supported version (what you would use for new projects) -- e.g. 3.2.1
* `.supported` -- Other supported versions, one per line -- e.g. 2.2.4 and 1.12.4
* `.old` -- All older released versions, one per line

Files in this folder should be named like:

* `BootstrapCDN-css-bootstrap.min.css.latest`
* `BootstrapCDN-css-bootstrap.min.css.supported`
* `BootstrapCDN-css-bootstrap.min.css.old`

where

* `BootstrapCDN` is the canonical name of the CDN
* `css-bootstrap.min.css` is the name of the relevant file (with `/` substituted to `-`)
