

# Middleman Template

[![deps][deps]][deps-url]

## Branches

| Branches   | Description |
|:-----------|:------------|
| master     | Source files [default branch] |
| production | Static files build from 'master' branch by [middleman](http://middlemanapp.com/jp/). |

### Get to start

```sh
git clone --recursive https://github.com/karappo/middleman-template.git <project-name>
cd <project-name>
npm run setup

# Change origin
git remote rm origin
git remote add origin <prorect repo url>
```


### Middleman commands

You can leave out `bundle exec` if you have added `./vendor/bin` to your $PATH in shell.

***Develop***

```sh
bundle exec middleman
```

Then you can preview site on [http://0.0.0.0:4567](http://0.0.0.0:4567)

Modify files under `source` directory.


***Build***

Build files in `source` to `build` dirctory

```sh
bundle exec middleman build
```

***Deploy***

Build files to `build` dirctory, and auto commit these files to specific branch (configured in config.rb).

```sh
bundle exec middleman deploy
```

[deps]: https://img.shields.io/david/naokazuterada/middleman-template.svg
[deps-url]: https://david-dm.org/naokazuterada/middleman-template
