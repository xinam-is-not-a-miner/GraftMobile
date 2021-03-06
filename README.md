# Graft Mobile Client for Linux

Clients:
* Point of Sale (POS)
* Wallet

More information about currently available clients features you can find 
[here](FEATURES.md).

## Build Settings ##
**POS**

If you want to build a POS project, you must open in `Build Settings`, open `Build Steps` and choose `Additional arguments:`

```
DEFINES+=POS_BUILD
```

**WALLET**

If you want to build a WALLET project, you must open in `Build Settings`, open `Build Steps` and choose `Additional arguments:`

```
DEFINES+=WALLET_BUILD
```

**TESTING**

For testing purposes on the desktop computer, you can use `RES_IOS` define to switch sources of the user interface. If you 
aren't use `RES_IOS` define, Android user interface is used by default. For example:

```
DEFINES+="WALLET_BUILD RES_IOS"
```

or

```
DEFINES+="POS_BUILD RES_IOS"
```

**Sparkle**

We have included the Sparkle updater for [macOS](https://sparkle-project.org/) and [Windows](https://winsparkle.org/) since 1.13.5 build. If you want to disable Sparkle when you build clients, you need to add `DISABLE_SPARKLE_UPDATER` to defines.

```
DEFINES+="DISABLE_SPARKLE_UPDATER"
```

## Cloning ##

Clone from upstream while borrowing from an existing local directory:

```
$ git clone --recursive https://git.vakoms.com/qt-team/graft-mobile-client.git
```

Also, if you run `git clone` **non-recursively**, you need to run:

```
$ git clone https://git.vakoms.com/qt-team/graft-mobile-client.git
$ git submodule init
$ git submodule update
```
