# agni

Writes TAR archive files. GZIP not supported, but you can use
gzip-stream.

## API

The package exposes a single function: `archive`. Here is its
signature:

```lisp
(defun archive (path-to-archive archive-path &optional (since 0))
```

The `since` parameter allows you to specify a timestamp since the last
change.

## License

MIT License.
