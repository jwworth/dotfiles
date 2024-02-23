```
 ____ ____ ____ ____ ____ ____ ____ ____
||d |||o |||t |||f |||i |||l |||e |||s ||
||__|||__|||__|||__|||__|||__|||__|||__||
|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
```

These are my dotfiles. They are heavily inspired by the [Hashrocket
Dotmatrix][dotmatrix].

Some hard-won advice: don't add a configuration to your environment that you
don't understand. If you don't know what a configuration does, you can waste
time fixing a 'bug' that was actually misconfiguration or expected behavior in
your setup. And every configuration is a tradeoff. It pays to know what that
tradeoff is.

### Installation

```
$ mkdir ~/oss
$ cd ~/oss
$ git clone https://github.com/jwworth/dotfiles.git
```

Next, run the install script:

```
$ bin/install
```

To set up a new Mac, run:

```
$ ./.macos
```

To use the [Husky][husky] scripts, copy `.husky/` to your Husky-enabled project.

### License

These dotfiles are released under the [MIT License][mit].

[dotmatrix]: https://github.com/hashrocket/dotmatrix
[mit]: http://www.opensource.org/licenses/MIT
[husky]: https://www.npmjs.com/package/husky
