Helicopter cli
---

Helicopter cli tool is a very simple util which load `helicopter.js` binary file
from current directory with lookup like node does and requires it. It search
installed `helicopter` inside node_modules folders.

It has no dependencies, extra lightweight and written in pure shell script.

## Install

```
npm install -g helicopter-cli
```

## Usage

Helicopter script pass all arguments to helicopter executable and redirect stdin.

```
helicopter [OPTIONS]
```

## Example

Run server

```shell
helicopter up 8080
```
