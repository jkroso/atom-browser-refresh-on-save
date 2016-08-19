# browser-refresh-on-save

When you save a file it tells the active tab in each of your selected browsers to run some JavaScript. Depending on which type of file that is it will run different code.

__Note:__ make sure you uncheck the browsers you aren't using in the settings. Otherwise it will display an error when trying to refresh that browser. PR which detect this case automatically are welcome

## Default behavior for each file type

- css,styl: reloads just the CSS files in the page without doing a full refresh
- js,md,html,jade: reload the whole page
- others: nothing

## Supported browsers

- Chrome
- Chrome Canary
- Safari
- Vivaldi

## Supported platforms

- Mac
