# nautilus-open-with-code

## TODO

- Test `.deb` package on a VM in order to check if the dependencies, including VS Code, are automatically installed.


## Tags and releases

```
git tag -a v0.1.0-alpha -m "Note: Not meant for production yet"
git show v0.1.0-alpha
git push origin --tags
gh release create v0.1.0-alpha ./dist/nautilus-open-with-code_0.1.0-alpha.deb --prerelease --title "nautilus-open-with-code v0.1.0-alpha" --notes "Not meant for production use yet."
```
