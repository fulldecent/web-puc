[![Build Status](https://travis-ci.org/fulldecent/web-puc.svg?branch=master)](https://travis-ci.org/fulldecent/web-puc)

web-puc
=======

**Web Package Update Checker** validates web projects to ensure they use the latest available versions of web packages.

Keep your web front-ends up to date by using us in your unit testing, we are compatible with Travis CI. This project supports web packages that are Javascript, CSS, and Fonts. We support ANY web front-end including HTML, PHP, Ruby, ASP.


Synopsis
========

Run this program with: `web-puc [OPTIONS] target ...`

**Program switches include:**

| Option              | Short      | Description                                         |
| ------------------- | ---------- | ------------                                        |
| `--exclude GLOB`    | `-e GLOB`  | Exclude from consideration all files matching GLOB  |
| `--allow-supported` | `-s`       | Allow supported versions even if not latest         |
| `--update`          | `-u`       | Update web package database                         |

**Return status is zero for success and non-zero if errors are found.**

**Output is of the form:**

````
ERROR
------------------------------------------
FILE: index2.php
RECOMMENDATION: //netdna.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css
INDICATION(S) BY LINE:
13://netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.min.css

ERROR
------------------------------------------
FILE: indexOLD.php
RECOMMENDATION: //netdna.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css
INDICATION(S) BY LINE:
14://netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome.min.css
15://netdna.bootstrapcdn.com/font-awesome/3.2.0/css/font-awesome.min.css
````


Project layout
==============

 - `web-puc.sh` - the main executible
 - `packages/` - database of package information
 - `package-spiders/` - tools for updating the `packages/` directory
 - `tests/` - unit tests


Package recogninition
=====================

We recognize packages by three types of matching:

 - **CDN**: is an inclusion (like `<script src=...` or `<link href=...`) to a file on a popular content distribution network. For example, when this was written, `//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css` was an old version, but `//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css` was current

 - **Identifier**: is a string like `Bootstrap v3.1.1 (http://getbootstrap.com)` which would indicate a file in your project contains specific code (`web-puc` gleans information from your files' contents, not names)
 
 - **Content Matcher**: is a string like `.form-control{position:relative;z-index:2;float:left;` that would indicate, for example, that are using Twitter Bootstrap 3.1.1 even if you later minify and package all your CSS files together


Project roadmap
===============

Please Star (or Watch!) this project for updates and to get involved. Following is a roadmap:

Version 0.0.2

 * Manually create recognizers for Bootstrap, jQuery, FontAwesome and other stuff I (we) care about
 * Test project on my live websites
 * Create more unit tests
 * Create sample github project that illustrates using **Web Package Update Checker** with Travis CI
 * Advertise the availability of this project

Later

 * Create automated spiders that update `packages/` for example
   * One could update all MaxCDN packages
   * One could follow RSS feeds for Bootstrap
 * Move `packages/` to a separate repository (and maybe `package-spiders/` too)
 * Update `web-puc.sh` to use `git pull` to pull down updates to `packages/` and warn if the database is too old
 * Advertise the availability of this project
