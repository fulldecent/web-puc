# Package List File Format

The files in this directory are a database of web packages. Web packages are things that you copy-paste or link into your web project. Examples include:

* `.css` files like [Bootstrap](http://getbootstrap.com/)
* `.ttf` files like [Font Awesome](http://fontawesome.io/)
* `.js` files like [jQuery](https://jquery.com/)

All good web projects regularly make new releases. We differentiate between different versions of these packages. Here is an example for jQuery:

* The newest supported version (what you would use for new projects) -- e.g. 3.2.1
* Other supported versions -- e.g. 2.2.4 and 1.12.4
* All other released versions

For each released product we have a `.good` file and a `.bad` file:

* `.good` lists the newest supported version first
* `.good` lists all other supported versions subsequently (see `--allow-supported` run time option)
* `.bad` lists all other released versions

Files SHOULD be named as follows:

`[REPOSITORY-]PROJECT-FILE.good` and `[REPOSITORY-]PROJECT-FILE.bad`
