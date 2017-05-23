# Contributing

## Making a new release

```sh
gem bump # and maybe use --version minor
rm web-puc-*.gem
gem build web-puc.gemspec
gem push web-puc-*.gem
```
