web-puc
=======

**Web Package Update Checker** validates your web project to ensure you use the latest available versions of web packages.

Keep your web front-ends up to date by using us in your unit testing, we will be compatible with Travis CI. This project will be compatible with web packages that are Javascript, CSS, and Fonts. We support ANY web frontent including HTML, PHP, Ruby, ASP.

####  PLEASE SEE "Project roadmap" AT BOTTOM AND STAR OR WATCH THIS PROJECT FOR UPDATES AND TO GET INVOLVED  ####


Synopsis
========

Run this program with: `web-puc [OPTIONS] target ...`

**Output will be of the form:**

````
ERROR
----------------------------------------------------
FILE: my-web-project/index.html
LINE: 14
PACKAGE: bootstrap
INCLUSION: //netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css
RECOMMENDATION: //netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css
DESCRIPTION: An old version of this package is included via CDN, a newer version is available

WARNING
----------------------------------------------------
FILE: my-web-project/index.css
LINE: 14
PACKAGE: bootstrap
INCLUSION: col-span-4
RECOMMENDATION: bootstrap 3.1.1 //netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css
DESCRIPTION: It appears that you have incorporated bootstrap 2.x code in a file, a newer version is available
````

**Program switches include:**

| Option              | Short      | Description                                                           |
| ------------------- | ---------- | ------------                                                          |
| `--exclude GLOB`    | `-e GLOB`  | Exclude from consideration all files matching GLOB                    |
| `--allow-supported` | `-s`       | Allow supported versions even if they aren't latest                   |
| `--no-canonical`    | `-c`       | Do not recommend changes to canonical versions (like `.min` versions) |
| `--opinionated`     | `-o`       | Emit a warning for using CDNs we don't recommend                      |
| `--update`          | `-u`       | Update database of package versions                                   |

**Return status is:**

| Return status | Mearning                      |
| ------------- | --------------                |
| 0             | No warnings or errors         |
| 1             | One or more warnings produced |
| 2             | One or more errors produced   |
| -1            | Input file(s) not readable    |
| >=3           | Other program error           |


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

 - **Identifier**: is a file in your project like `bootstrap.min.css` which contains a string such as `Bootstrap v3.1.1 (http://getbootstrap.com)` which is the identifier line in the file
 
 - **Content Matcher**: is a file that includes like `.form-control{position:relative;z-index:2;float:left;` which is a unique string that belongs to the 3.1.1 (or later) version of Bootstrap

Example of a package file: (will be moved to `packages/bootstrap/3.1.1` when the project is stable)

````
{
   "project":"bootstrap",
   "version":"3.1.1",
   "versionSupported":true,
   "versionLatest":true,
   "homepage":"http://getbootstrap.com/"
   "cdns":
   [
      {
         "name":"Bootstrap DNA",
         "preferred":true,
         "homepage":"http://www.bootstrapcdn.com/",
         "canonicalURL":"//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css",
         "otherURLs":[]
      },
      ...
   ],
   "identifiers":
   [
      "Bootstrap v3.1.1 (http://getbootstrap.com)"
   ],
   "contentMatchers":
   [
      {
         "indication":".form-control{position:relative;z-index:2;float:left;",
         "contraindication":null ## Put something here that would identify 3.1.2 and later
      }
   ]
}
````


Project roadmap
===============

Please Star (or Watch!) this project for updates and to get involved. Following is a roadmap:

Version 0.0.1

 * Get recognizers for several recent versions of Bootstrap manually set up
 * Create `web-puc.sh`
 * Test project on my live websites
 * Advertise the availability of this project

Version 0.0.2

 * Manually create recognizers for Bootstrap, jQuery, FontAwesome and other stuff I (we) care about
 * Test project on my live websites
 * Create test cases and set up Travis
   * Validate JSON formatting of package files
   * Create sample input files and test efficacy of `web-puc.sh`
   * Test each command switch of `web-puc.sh`
 * Create sample github project that illustrates using **Web Package Update Checker** with Travis CI
 * Advertise the availability of this project

Later

 * Create automated spiders that update `packages/` for example
   * One could update all MaxCDN packages
   * One could follow RSS feeds for Bootstrap
 * Move `packages/` to a separate repository (and maybe `package-spiders/` too)
 * Update `web-puc.sh` to use `git pull` to pull down updates to `packages/` and warn if the database is too old
 * Advertise the availability of this project
