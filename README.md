# dotfiles

> The expectations of life depend upon diligence; the mechanic that would
> perfect his work must first sharpen his tools. —Confucius

These are my local dotfiles for configuring an OSX machine to my personal
preferences. They are meant to supplement or override the excellent settings
found in the [Hashrocket Dotmatrix](https://github.com/hashrocket/dotmatrix).

### Installation

```
$ cd code_directory
$ git clone https://github.com/jwworth/dotfiles.git
```

Next, create a symlink for each file from the root directory:

```
$ ln -s  ~/code_directory/dotfiles/.example.local ~/
```

Then, install dependencies:

```
$ gem install rubocop
$ yarn add -g hamllint
$ yarn add -g eslint
```

### License

These dotfiles are released under the [MIT
License](http://www.opensource.org/licenses/MIT).
