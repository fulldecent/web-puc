web-puc [![Build Status](https://travis-ci.org/fulldecent/web-puc.svg?branch=master)](https://travis-ci.org/fulldecent/web-puc)
=======

**Web Package Update Checker** validates web projects to ensure they use the latest available versions of web packages (like Bootstrap, Font Awesome, JQuery).

Keep your web front-ends up to date by using us in your unit testing, we are compatible with Travis CI. We support web packages that are included via CDN as well as mix-ins and Javascript/CSS/Fonts that are subsetted or compiled into your own files! We support ANY web front-end including HTML, PHP, Ruby, ASP, Cold Fusion.

For an implemented example of using `web-puc` with Travis CI for integration testing, please see https://github.com/fulldecent/sourcespeak and <a href="https://github.com/fulldecent/sourcespeak/blob/master/.travis.yml">its `.travis.yml` file</a>.


Synopsis
========

`web-puc [-e glob] [-s] [-u] target ...`
    
**The following options are available:**

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

 - **CDN**: is an inclusion (like `<script src="...">` or `<link href="...">`) to a file on a popular content distribution network. For example, when this was written, `//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css` was an old version, but `//netdna.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css` was current

 - **Identifier**: is a string like `Bootstrap v3.0.0 (http://getbootstrap.com)` which would indicate a file in your project contains specific code (`web-puc` gleans information from your files' contents, not names)
 
 - **Content Matcher**: is a string like `.form-control{position:relative;z-index:2;float:left;` that would indicate, for example, that are using Twitter Bootstrap 3.1.1 even if you later minify and package all your CSS files together


Project roadmap
===============

Please Star (or Watch!) this project for updates and to get involved. Following is a roadmap:

 * Create more package-updaters for all MaxCDN packages and JQuery
 * Store `packages/` and `package-spiders/` in a separate repository and have `web-puc.sh` use `git pull` to update
 * Have `web-put.sh` warn if `packages/` was updated too long ago (like Composer)
 * Advertise the availability of this project
