# Firefox theme

A flat, minimal One Dark Darker theme in the spirit of SimpleFox.
The tab bar only shows with two or more tabs, the address bar is slim, and the suggestion dropdown is hidden.

- `chrome/userChrome.css`: browser UI
- `chrome/userContent.css`: about: pages, thin scrollbars, selection colour
- `user.js`: enables userChrome and sets the dark content theme

## Install

    ./install [profile-dir]

Defaults to the `default-release` profile. Restart Firefox afterwards.
To undo, remove the `chrome` and `user.js` symlinks from the profile.

## Upgrades

Firefox renames internal selectors now and then. If something looks off, inspect it with the browser toolbox and update the selector.
