# browser-refresh-on-save

When you save a file it tells the active tab in each of your selected browsers to run some JavaScript. Depending on which type of file that is it will run different code.

- css,styl,less: reloads just the CSS files in the page without doing a full refresh 
- everything else: reloads the whole page

__Note:__ make sure you uncheck the browsers you aren't using in the settings. Otherwise it will display an error when trying to refresh that browser. PR which detect this case automatically are welcome

## Supported browsers

- Chrome
- Chrome Canary
- Safari
- Vivaldi

## Supported platforms

- Mac
